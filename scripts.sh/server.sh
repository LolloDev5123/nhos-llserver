#!/bin/sh

# NHOS Local Log Server
# By @totakaro 2021
# MIT License

# Edit your IP or IP range allowed to access this server here, alsp see https://nmap.org/ncat/guide/ncat-access.html
ALLOW="192.168.0.0/24"

# Check if NHOS logs are available to generate index.html
while sleep 1; do
if [ -d "/var/log/nhos/nhm" ]; then
cat <<-HTML > /tmp/index.html
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABkAAAAYAQMAAAA1e8SFAAAAA1BMVEX7o0IDE259AAAAC0lEQVQI12MYIAAAAHgAAUPP7CoAAAAASUVORK5CYII=" type="image/x-icon">
    <title>NHOS Local Log Server</title>
    <style>
      #logs span,
      #rig span {
        color: lightgray;
      }

      body {
        margin: 0;
        font-family: sans-serif
      }

      h1 {
        font-size: 1rem;
        font-weight: bold;
        margin: 0;
        padding: 0;
        display: inline;
      }

      #logs,
      #rig {
        padding: 5px;
        color: lightgray;
        background: black;
        margin: 0;
        overflow-x: auto;
      }

      #rig {
        white-space: pre-wrap;
      }

      #tools {
        position: fixed;
        background: white;
        width: 100%;
        top: 0;
        padding: 10px;
        box-sizing: border-box;
        border-top: 3px #fba342 solid;
      }

      #oc-settings {
        padding: 5px;
        color: lightgray;
        background: #272727;
        margin: 0;
        width: 100%;
        height: 80vh;
        border: 0;
        box-sizing: border-box;
        border-radius: 0;
        white-space: nowrap;
      }

      #oc-settings:focus {
        outline: 0;
      }

      #info,
      #oc-title,
      #logs-title {
        background: #3e3e3e;
        font-weight: bold;
      }

      #info,
      #oc-title,
      #logs-title,
      #setup {
        color: #dedede;
        font-family: monospace;
        padding: 5px;
      }

      #setup {
        background: #272727;
      }

      #setup,
      #tools {
        overflow-x: scroll;
        white-space: nowrap;
      }

      #oc-title,
      #oc-save {
        display: none;
      }

      #setup input[type="range"] {
        margin-right: 20px;
      }

      input[type="number"]:focus {
        outline: 0;
      }

      #setup input[type="number"] {
        width: 50px;
        margin-right: 10px;
        background: #d3d1d1;
        border: 0;
        color: #151515;
      }
    </style>
  </head>

  <body>
    <div id="tools">
      <h1>NHOS Local Log Server <sup><small><a href="https://github.com/totakaro/nhos-llserver/releases" target="_blank"
              id="version">v1.0.5</a></small></sup></h1> | 
      <button id="top">Go Top</button> | 
      <button id="bottom">Go Bottom</button> | 
      <button id="clear">Clear tab logs</button> | 
      <button id="reboot">Reboot rig</button> | 
      <button id="oc">OC Settings</button> <button id="oc-save">Save OC</button> | 
      <label for="autoscroll">AutoScroll?</label>
      <input type="checkbox" name="autoscroll" id="autoscroll" checked=""> | 
      <label for="color">Color?</label> <input type="checkbox" name="color" id="color" checked="">
    </div>
    <div id="info">Basic Rig Infomation</div>
    <pre id="rig"></pre>
    <label for="oc-settings" id="oc-title">OC Settings</label>
    <div id="setup">
    </div>
    <textarea id="oc-settings" style="display: none;" spellcheck="false"></textarea>
    <div id="logs-title">Miners Logs</div>
    <pre id="logs"></pre>
    <script src="https://cdn.jsdelivr.net/npm/ansi_up@5.0.0/ansi_up.js"
      integrity="sha256-hvLefrSZwtORL7LIUdbClzIqvJ3UW3kutOrxlWL300s=" crossorigin="anonymous"></script>
    <script>
  (function(){
      // Vars
      var autoscroll = document.getElementById("autoscroll")
      var bottom = document.getElementById("bottom")
      var clear = document.getElementById("clear")
      var color = document.getElementById("color")
      var dotsIntervals = []  // Loading dots
      var info = document.getElementById("info")
      var logs = document.getElementById("logs")
      var logsTitle = document.getElementById("logs-title")
      var oc = document.getElementById("oc")
      var ocSave = document.getElementById("oc-save")
      var ocSettings = document.getElementById("oc-settings")
      var ocTitle = document.getElementById("oc-title")
      var reboot = document.getElementById("reboot")
      var rig = document.getElementById("rig")
      var setup = document.getElementById("setup")
      var top_ = document.getElementById("top")
      var tools = document.getElementById("tools")
      var version = document.getElementById("version")
      

      // Polyfill if no AnsiUp 3rd party available
      if (typeof AnsiUp === "undefined") {
        AnsiUp = function () { }
        // Remove color tags because no AnsiUp available
        AnsiUp.prototype.ansi_to_html = function (data) {
          return data.replace(/.\[(\d+;)?\d+m/g, "")
        }
        // Disable color because no AnsiUp available
        color.checked = false
        color.addEventListener("click", function (e) {
          e.preventDefault()
          alert("This feature requires the 3rd party library ansi_up.js")
        })
      }

      var ansi_up = new AnsiUp

      // Calculate top_ margin for fixed tools bar
      info.style.marginTop = tools.offsetHeight + "px"

      // Change color status
      color.addEventListener("change", function () {
        if (color.checked) {
          document.styleSheets[0].deleteRule(0)
        } else {
          document.styleSheets[0].insertRule("#logs span, #rig span { color: lightgray !important;}", 0)
        }
      })

      // All inputs
      function guiSetup(element) {
        var json = JSON.parse(element.value)
        if (json["detected_devices"].length === 0) {
          setup.insertAdjacentText("beforeend", "No devices found, wait for NHOS to generate device_settings.json and try reopen OC settings again.")
          return
        }
        json["detected_devices"].forEach(function (device) {
          setup.insertAdjacentText("beforeend", "Device: " + device["name"] + " " + device["device_id"])
          setup.insertAdjacentHTML("beforeend", "<br>")
          device["algorithms"].forEach(function (algo) {
            setup.insertAdjacentHTML("beforeend", "Miner: " + algo["miner"] + " on power modes low, medium and high")
            setup.insertAdjacentHTML("beforeend", "<br>")
            algo["power"].forEach(function (mode) {
              let label0, label1, label2, range0, range1, range2, number0, number1, number2
              label0 = document.createElement("label")
              label1 = document.createElement("label")
              label2 = document.createElement("label")
              range0 = document.createElement("input")
              range1 = document.createElement("input")
              range2 = document.createElement("input")
              number0 = document.createElement("input")
              number1 = document.createElement("input")
              number2 = document.createElement("input")
              range0.max = 100
              range0.min = 0
              range0.step = 1
              range1.max = 5000
              range1.min = -5000
              range1.step = 1
              range2.max = 5000
              range2.min = -5000
              range2.step = 1
              number0.max = 100
              number0.min = 0
              number0.step = 1
              number1.max = 5000
              number1.min = -5000
              number1.step = 1
              number2.max = 5000
              number2.min = -5000
              number2.step = 1
              range0.type = "range"
              range1.type = "range"
              range2.type = "range"
              number0.type = "number"
              number1.type = "number"
              number2.type = "number"
              range0.value = mode["tdp"]
              range1.value = mode["core_clocks"]
              range2.value = mode["memory_clocks"]
              label0.textContent = "TDP "
              label1.textContent = "CLOCK "
              label2.textContent = "MEMORY "
              number0.value = range0.value
              number1.value = range1.value
              number2.value = range2.value
              setup.appendChild(label0)
              setup.appendChild(number0)
              setup.appendChild(range0)
              setup.appendChild(label1)
              setup.appendChild(number1)
              setup.appendChild(range1)
              setup.appendChild(label2)
              setup.appendChild(number2)
              setup.appendChild(range2)
              setup.insertAdjacentHTML("beforeend", "<br>")
              range0.addEventListener("input", function (e) {
                number0.value = range0.value
                mode["tdp"] = parseInt(range0.value)
                element.value = JSON.stringify(json, null, "\t")
              })
              range1.addEventListener("input", function (e) {
                number1.value = range1.value
                mode["core_clocks"] = parseInt(range1.value)
                element.value = JSON.stringify(json, null, "\t")
              })
              range2.addEventListener("input", function (e) {
                number2.value = range2.value
                mode["memory_clocks"] = parseInt(range2.value)
                element.value = JSON.stringify(json, null, "\t")
              })
              number0.addEventListener("input", function (e) {
                range0.value = number0.value
                mode["tdp"] = parseInt(number0.value) || 0
                element.value = JSON.stringify(json, null, "\t")
              })
              number1.addEventListener("input", function (e) {
                range1.value = number1.value
                mode["core_clocks"] = parseInt(number1.value) || 0
                element.value = JSON.stringify(json, null, "\t")
              })
              number2.addEventListener("input", function (e) {
                range2.value = number2.value
                mode["memory_clocks"] = parseInt(number2.value) || 0
                element.value = JSON.stringify(json, null, "\t")
              })
            })
          })
        })
      }

      // Move to top_
      top_.addEventListener("click", function () {
        window.scrollTo(0, 0)
      })

      // Move to bottom
      bottom.addEventListener("click", function () {
        window.scrollTo(0, document.body.scrollHeight)
      })

      // Clear current logs and loads new ones
      clear.addEventListener("click", function () {
        if (confirm("Are you sure to clear logs in this tab?")) {
          logs.textContent = "Loading new logs"
          dotsIntervals.push(setInterval(function () {
            logs.insertAdjacentText("beforeend", ".")
          }, 1000))
        }
      })

      // Rig reboot
      reboot.addEventListener("click", function () {
        if (confirm("Are you sure to reboot your rig?")) {
          fetch("/reboot", { method: "POST" })
            .then(function (response) { return response.text() }).then(function (text) { alert("Reboot request executed! " + text) }).catch(function (error) { alert("Error comunicating with local server, reboot probably in progress. " + error) })
        }
      })

      // Show or Close OC Settings
      oc.addEventListener("click", async function () {
        if (ocSettings.style.display === "none") {
          if (!confirm("CAUTION: OC can damage your hardware, edit only if you know what you are doing! Do you wanna continue?")) {
            return
          }
          fetch("/device_settings.json")
            .then(function (response) {
              return response.json()
            })
            .then(function (json) {
              oc.textContent = "Close OC Settings"
              ocTitle.style.display = "block"
              ocSave.style.display = "inline-block"
              autoscroll.checked = false
              top_.click()
              ocSettings.value = JSON.stringify(json, null, "\t")
              ocSettings.style.display = "block"
              guiSetup(ocSettings)
            })
            .catch(function (error) {
              alert("Error comunicating with local server. " + error)
            })
        } else {
          setup.textContent = ""
          oc.textContent = "OC Settings"
          autoscroll.checked = true
          ocTitle.style.display = "none"
          ocSave.style.display = "none"
          ocSettings.style.display = "none"
        }
      })

      // Save OC Settings
      ocSave.addEventListener("click", async function () {
        try {
          JSON.parse(ocSettings.value)
        } catch (err) {
          alert("Error in your OC Settings, please check again: " + err)
          return
        }
        fetch("/device_settings.json", { method: "POST", body: ocSettings.value + "\n" })
          .then(function (response) {
            return response.text()
          })
          .then(function (text) {
            if (confirm("Settings saved successfully! Wanna reboot to apply changes?")) {
              reboot.click()
            }
          })
          .catch(function (error) {
            alert("Error saving OC settings in local server, reboot probably in progress " + error)
          })
      })

      // Gets Basic Rig information
      rig.insertAdjacentHTML("beforeend", ansi_up.ansi_to_html("`head -1 /var/log/nhos/nhm/*.log`"))
      rig.insertAdjacentHTML("beforeend", "<br>")
      rig.insertAdjacentHTML("beforeend", ansi_up.ansi_to_html("`head -2 /var/log/nhos/nhm/*.log | tail -1`"))

      // Adds Loading and count dots
      logs.insertAdjacentText("beforeend", "Loading")
      dotsIntervals.push(setInterval(function () {
        logs.insertAdjacentText("beforeend", ".")
      }, 1000))

      // Connects to Server Sent Events
      new EventSource("http://" + window.location.hostname + ":8081/").onmessage = function (e) {
        // Stop Loading dots
        dotsIntervals.forEach(function(dotInterval) {
          clearInterval(dotInterval)
        })
        // Limit logs history to 1000 lines
        if (logs.childElementCount > 1000) {
          while (logs.childElementCount > 1000) {
            logs.removeChild(logs.firstChild)
          }
        }
        setTimeout(function () {
          logs.insertAdjacentHTML("beforeend", "<br>")
          logs.insertAdjacentHTML("beforeend", ansi_up.ansi_to_html(e.data))
          // AutoScroll if enabled
          if (autoscroll.checked) {
            window.scrollTo(0, document.body.scrollHeight)
          }
        }, 100)
      }

      // Gets current version and compares it with the latest version
      fetch("https://api.github.com/repos/totakaro/nhos-llserver/releases/latest")
        .then(function (response) { return response.json() }).then(function (json) {
          let currentVersion = json["tag_name"]
          version
          if (version.textContent !== currentVersion) {
            version.insertAdjacentText("beforeend", " (Upgrade to " + currentVersion + ")")
          }
        })
  }.bind(this))()
    </script>
  </body>

  </html>
HTML
break
fi
done&

# SSE (Server Sent Events) server
ncat -n4 -lk -p 8081 --allow $ALLOW --sh-exec "echo -e 'HTTP/1.1 200 OK\r\nAccess-Control-Allow-Origin: *\r\nContent-type: text/event-stream\r\n'; tail -f /var/log/nhos/nhm/miners/*.log /var/log/nhos/*.log 2>/dev/null | sed -e 's/^/data: /;s/$/\n/'"&

# Main server
# Based from Lua httpd server https://github.com/nmap/nmap/blob/master/ncat/scripts/httpd.lua
cat <<-'LUA' > /tmp/httpd.lua
  --httpd.lua - a dead simple HTTP server. Expects GET requests and serves files
  --matching these requests. Can guess mime based on an extension too. Currently
  --disallows any filenames that start or end with "..".

  ------------------------------------------------------------------------------
  --                          Configuration section                           --
  ------------------------------------------------------------------------------

  server_headers = {
      ["Server"] = "Ncat --lua-exec httpd.lua",
      ["Connection"] = "close",
  }

  function guess_mime(resource)
      if string.sub(resource, -5) == ".html" then return "text/html" end
      if string.sub(resource, -5) == ".json" then return "application/json" end
      return "application/octet-stream"
  end

  ------------------------------------------------------------------------------
  --                       End of configuration section                       --
  ------------------------------------------------------------------------------

  function print_rn(str)
      io.stdout:write(str .. "\r\n")
      io.stdout:flush()
  end

  function debug(str)
      io.stderr:write("[" .. os.date() .. "] ")
      io.stderr:write(str .. "\n")
      io.stderr:flush()
  end

  function url_decode(str)
      --taken from here: http://lua-users.org/wiki/StringRecipes
      return str:gsub("%%(%x%x)",
          function(h) return string.char(tonumber(h,16)) end)
  end

  --Read a line of at most 8096 bytes (or whatever the first parameter says)
  --from standard input. Returns the string and a boolean value that is true if
  --we hit the newline (defined as "\n") or false if the line had to be
  --truncated. This is here because io.stdin:read("*line") could lead to memory
  --exhaustion if we received gigabytes of characters with no newline.
  function read_line(max_len)
      local ret = ""
      for i = 1, (max_len or 8096) do
          local chr = io.read(1)
          if chr == "\n" then
              return ret, true
          end
          ret = ret .. (chr or "")
      end

      return ret, false
  end

  --The following function and variables was translated from Go to Lua. The
  --original code can be found here:
  --
  --http://golang.org/src/pkg/unicode/utf8/utf8.go#L45
  local surrogate_min = 0xD800
  local surrogate_max = 0xDFFF

  local t1 = 0x00 -- 0000 0000
  local tx = 0x80 -- 1000 0000
  local t2 = 0xC0 -- 1100 0000
  local t3 = 0xE0 -- 1110 0000
  local t4 = 0xF0 -- 1111 0000
  local t5 = 0xF8 -- 1111 1000

  local maskx = 0x3F -- 0011 1111
  local mask2 = 0x1F -- 0001 1111
  local mask3 = 0x0F -- 0000 1111
  local mask4 = 0x07 -- 0000 0111

  local char1_max = 0x7F    -- (1<<7)  - 1
  local char2_max = 0x07FF  -- (1<<11) - 1
  local char3_max = 0xFFFF  -- (1<<16) - 1

  local max_char = 0x10FFFF -- \U0010FFFF

  function get_next_char_len(p)
      local n = p:len()
      local c0 = p:byte(1)

      --1-byte, 7-bit sequence?
      if c0 < tx then
          return 1
      end

      --unexpected continuation byte?
      if c0 < t2 then
          return nil
      end

      --need first continuation byte
      if n < 2 then
          return nil
      end
      local c1 = p:byte(2)
      if c1 < tx or t2 <= c1 then
          return nil
      end

      --2-byte, 11-bit sequence?
      if c0 < t3 then
          local l1 = bit32.lshift(bit32.band(c0,mask2),6)
          local l2 = bit32.band(c1,maskx)
          local r = bit32.bor(l1, l2)
          if r <= char1_max then
              return nil
          end
          return 2
      end

      --need second continuation byte
      if n < 3 then
          return nil
      end
      local c2 = p:byte(3)
      if c2 < tx or t2 <= c2 then
          return nil
      end

      --3-byte, 16-bit sequence?
      if c0 < t4 then
          local l1 = bit32.lshift(bit32.band(c0, mask3), 12)
          local l2 = bit32.lshift(bit32.band(c1, maskx), 6)
          local l3 = bit32.band(c2, maskx)
          local r = bit32.bor(l1, l2, l3)
          if r <= char2_max then
              return nil
          end
          if surrogate_min <= r and r <= surrogate_max then
              return nil
          end
          return 3
      end

      --need third continuation byte
      if n < 4 then
          return nil
      end
      local c3 = p:byte(4)
      if c3 < tx or t2 <= c3 then
          return nil
      end

      --4-byte, 21-bit sequence?
      if c0 < t5 then
          local l1 = bit32.lshift(bit32.band(c0, mask4),18)
          local l2 = bit32.lshift(bit32.band(c1, maskx), 12)
          local l3 = bit32.lshift(bit32.band(c2, maskx), 6)
          local l4 = bit32.band(c3, maskx)
          local r = bit32.bor(l1,l2,l3,l4)
          if r <= char3_max or max_char < r then
              return nil
          end
          return 4
      end

      --error
      return nil
  end

  function validate_utf8(s)
      local i = 1
      local len = s:len()
      while i <= len do
          local size = get_next_char_len(s:sub(i))
          if size == nil then
              return false
          end
          i = i + size
      end
      return true
  end

  --Returns a table containing the list of directories resulting from splitting
  --the argument by '/'.
  function split_path(path)
      --[[
      for _, v in pairs({"/a/b/c", "a/b/c", "//a/b/c", "a/b/c/", "a/b/c//"}) do
          print(v,table.concat(split_path(v), ','))
      end

      -- /a/b/c  ,a,b,c
      -- a/b/c   a,b,c
      -- //a/b/c ,,a,b,c
      -- a/b/c/  a,b,c
      -- a/b/c// a,b,c,
      ]]
      local ret  = {}
      local j = 0
      for i=1, path:len() do
          if path:sub(i,i) == '/' then
              if j == 0 then
                  ret[#ret+1] = path:sub(1, i-1)
              else
                  ret[#ret+1] = path:sub(j+1, i-1)
              end
              j = i
          end
      end
      if j ~= path:len() then
          ret[#ret+1] = path:sub(j+1, path:len())
      end
      return ret
  end


  function is_path_valid(resource)
      --remove the beginning slash
      resource = string.sub(resource, 2, string.len(resource))

      --Windows drive names are not welcome.
      if resource:match("^([a-zA-Z]):") then
          return false
      end

      --if it starts with a dot or a slash or a backslash, forbid any acccess to it.
      first_char = resource:sub(1, 1)

      if first_char == "." then
          return false
      end

      if first_char == "/" then
          return false
      end

      if resource:find("\\") then
          return false
      end

      for _, directory in pairs(split_path(resource)) do
          if directory == '' then
              return false
          end

          if directory == '..' then
              return false
          end
      end

      return true
  end

  --Make a response, output it and stop execution.
  --
  --It takes an associative array with three optional keys: status (status line)
  --and headers, which lists all additional headers to be sent. You can also
  --specify "data" - either a function that is expected to return nil at some
  --point or a plain string.
  function make_response(params)

      --Print the status line. If we got none, assume it's all okay.
      if not params["status"] then
          params["status"] = "HTTP/1.1 200 OK"
      end
      print_rn(params["status"])

      --Send the date.
      print_rn("Date: " .. os.date("!%a, %d %b %Y %H:%M:%S GMT"))

      --Send the server headers as described in the configuration.
      for key, value in pairs(server_headers) do
          print_rn(("%s: %s"):format(key, value))
      end

      --Now send the headers from the parameter, if any.
      if params["headers"] then
          for key, value in pairs(params["headers"]) do
              print_rn(("%s: %s"):format(key, value))
          end
      end

      --If there's any data, check if it's a function.
      if params["data"] then

          if type(params["data"]) == "function" then

              print_rn("")
              --debug("Starting buffered output...")

              --run the function and print its contents, until we hit nil.
              local f = params["data"]
              while true do
                  ret = f()
                  if ret == nil then
                      --debug("Buffered output finished.")
                      break
                  end
                  io.stdout:write(ret)
                  io.stdout:flush()
              end

          else

              --It's a plain string. Send its length and output it.
              --debug("Just printing the data. Status='" .. params["status"] .. "'")
              print_rn("Content-length: " .. params["data"]:len())
              print_rn("")
              io.stdout:write(params["data"])
              io.stdout:flush()

          end
      else
          print_rn("")
      end

      os.exit(0)
  end

  function make_error(error_str)
      make_response({
          ["status"] = "HTTP/1.1 "..error_str,
          ["headers"] = {["Content-type"] = "text/html"},
          ["data"] = "<h1>"..error_str.."</h1>",
      })
  end

  do_400 = function() make_error("400 Bad Request") end
  do_403 = function() make_error("403 Forbidden") end
  do_404 = function() make_error("404 Not Found") end
  do_405 = function() make_error("405 Method Not Allowed") end
  do_414 = function() make_error("414 Request-URI Too Long") end

  ------------------------------------------------------------------------------
  --                         End of library section                           --
  ------------------------------------------------------------------------------

  input, success = read_line()

  --debug("Input: " .. input)

  --if not success then
  --    do_414()
  --end

  --if input:sub(-1) == "\r" then
  --    input = input:sub(1,-2)
  --end

  --We assume that:
  -- * a method is alphanumeric uppercase,
  -- * resource may contain anything that's not a space,
  -- * protocol version is followed by a single space.
  method, resource, protocol = input:match("([A-Z]+) ([^ ]+) ?(.*)")

  --if resource:find(string.char(0)) ~= nil then
  --    do_400()
  --end

  --if not validate_utf8(resource) then
  --    do_400()
  --end

  --if method ~= "GET" then
  --    do_405()
  --end

  buffer = ""
  if method == "GET" then
    if resource == "/" then
      resource = "/tmp/index.html"
    elseif method == "GET" and resource == "/device_settings.json" then
      resource = "/mnt/nhos/nhm/configs/device_settings.json"
    end
  elseif method == "POST" then
    if resource == "/device_settings.json" then
      resource = "/mnt/nhos/nhm/configs/device_settings.json"
      while true do
          input = read_line()
          --debug("Input: " .. input)
          if string.find(input, "^{") or buffer ~= "" then
            buffer = buffer .. input .. "\n"
          end
          if string.find(input, "^}") then
              break
          end
      end
    elseif resource == "/reboot" then
      os.execute("sudo reboot&")
      make_response({
          ["data"] = "Rebooting...",
          ["headers"] = {["Content-type"] = "text/plain"},
      })
    end
  end

  --debug("Got a request for '" .. method .. resource .. "' (urldecoded: '" .. url_decode(resource) .. "')." .. input)
  --resource = url_decode(resource)

  --make sure that the resource starts with a slash.
  --if resource:sub(1, 1) ~= '/' then
  --    do_400() --could probably use a fancier error here.
  --end

  --if not is_path_valid(resource) then
  --    do_403()
  --end

  --try to make all file openings from now on relative to the NHOS working directory.
  --resource = "./" .. resource

  --If it's a directory, try to load index.html from it.
  --if resource:sub(-1) == "/" then
  --    resource = resource .. '/index.html'
  --end

  --try to open the file...
  if buffer ~= "" then
    f = io.open(resource, "w")
  else
    f = io.open(resource, "rb")
  end
  if f == nil then
      if resource == "/mnt/nhos/nhm/configs/device_settings.json" then
        --opening file failed, wait for NHOS to generate device_settings.json.
        make_response({
            ["status"] = "HTTP/1.1 ".."404 Not Found",
            ["headers"] = {["Content-type"] = "application/json"},
            ["data"] = "{\"detected_devices\": []}",
        })
        debug("Error on resource " .. resource)
      else
        do_404()
      end
  elseif buffer ~= "" then
      os.execute("chmod +w "..resource)
      f:write(buffer)
      os.execute("chmod -w "..resource)
  end

  --and output it all.
  make_response({
      ["data"] = function() return f:read(1024) end,
      ["headers"] = {["Content-type"] = guess_mime(resource)},
  })
LUA

ncat -n4 -lk -p 80 --allow $ALLOW --lua-exec /tmp/httpd.lua&
