#!/bin/bash

# Edit your IP or IP range here check https://nmap.org/ncat/guide/ncat-access.html
ALLOW="192.168.0.0/24"

while sleep 1; do
if [ -d "/var/log/nhos/nhm" ]; then
read -r -d '' INDEX <<-HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon"> 
  <title>NHOS Local Log Server</title>
  <style>
    #logs span, #rig span {
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

    #logs, #rig {
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

    #info, #oc-title, #logs-title {
      background: #3e3e3e;
    }

    #info, #oc-title, #logs-title, #setup {
      color: #dedede;
      font-family: monospace;
      padding: 5px;
      font-weight: bold;
    }

    #setup {
      background: #272727;
    }

    #setup, #tools {
      overflow-x: scroll;
      white-space: nowrap;
    }

    #oc-title, #oc-save {
      display: none;
    }

    #setup label {
      width: 100px;
      display: inline-block;
    }

    #setup input[type="range"] {
        margin-right: 20px;
    }
  </style>
</head>

<body>
  <div id="tools"><h1>NHOS Local Log Server <sup><small>v1.0.0</small></sup></h1> | <button id="top">Go Top</button> | <button id="bottom">Go Bottom</button> | <button id="clear">Clear tab logs</button> | <button id="reboot">Reboot rig</button> | <button id="oc">OC Settings</button> <button id="oc-save">Save OC</button> | <label for="autoscroll">AutoScroll?</label> <input type="checkbox" name="autoscroll" id="autoscroll" checked=""> | <label for="color">Color?</label> <input type="checkbox" name="color" id="color" checked=""></div>
  <div id="info">Basic Rig Infomation</div>
  <pre id="rig"></pre>
  <label for="oc-settings" id="oc-title">OC Settings</label>
  <div id="setup">
  </div>
  <textarea id="oc-settings" style="display: none;" spellcheck="false"></textarea>
  <div id="logs-title">Miners Logs</div>
  <pre id="logs"></pre>
  <script src="https://cdn.jsdelivr.net/npm/ansi_up@5.0.0/ansi_up.js" integrity="sha256-hvLefrSZwtORL7LIUdbClzIqvJ3UW3kutOrxlWL300s=" crossorigin="anonymous"></script>
  <script>
    // DOM vars
    var rig = document.getElementById("rig")
    var info = document.getElementById("info")
    var ocTitle = document.getElementById("oc-title")
    var logsTitle = document.getElementById("logs-title")
    var logs = document.getElementById("logs")
    var color = document.getElementById("color")
    var top_ = document.getElementById("top")
    var bottom = document.getElementById("bottom")
    var clear = document.getElementById("clear")
    var reboot = document.getElementById("reboot")
    var oc = document.getElementById("oc")
    var ocSave = document.getElementById("oc-save")
    var ocSettings = document.getElementById("oc-settings")
    var autoscroll = document.getElementById("autoscroll")
    var setup = document.getElementById("setup")
    var dots; // Loading dots

    // Polyfill if no AnsiUp 3rd party available
    if (typeof AnsiUp === "undefined") {
      function AnsiUp() {}
      // Remove color tags because no AnsiUp available
      AnsiUp.prototype.ansi_to_html = function (data) {
        return data.replace(/.\[(\d+;)?\d+m/g, "")
      }
      // Disable color because no AnsiUp available
      color.checked = false
      color.addEventListener("click", function(e) {
        e.preventDefault()
        alert("This feature requires the 3rd party library ansi_up.js")
      })
    }

    var ansi_up = new AnsiUp
    
    // Calculate top margin for fixed tools bar
    info.style.marginTop = tools.offsetHeight + "px"

    // Change color status
    color.addEventListener("change", function() {
      if (color.checked) {
        document.styleSheets[0].deleteRule(0)
      } else {
        document.styleSheets[0].insertRule("#logs span, #rig span { color: lightgray !important;}", 0)
      }
    })

    // All inputs
    function guiSetup(element) {
      var json = JSON.parse(element.value)
      json["detected_devices"].forEach(function(device) {
        setup.insertAdjacentText("beforeend", device["name"] + " " + device["device_id"] + ": power modes (low, medium, high)")
          setup.insertAdjacentHTML("beforeend", "<br>")
        device["algorithms"].forEach(function(algo) {
          algo["power"].forEach(function(mode) {
            let label0, label1, label2, range0, range1, range2
            label0 = document.createElement("label")
            label1 = document.createElement("label")
            label2 = document.createElement("label")
            range0 = document.createElement("input")
            range1 = document.createElement("input")
            range2 = document.createElement("input")
            range0.max = 100
            range0.min = 0
            range0.step = 1
            range1.max = 5000
            range1.min = -5000
            range1.step = 1
            range2.max = 5000
            range2.min = -5000
            range2.step = 1
            range0.type = "range"
            range1.type = "range"
            range2.type = "range"
            range0.value = mode["tdp"]
            range1.value = mode["core_clocks"]
            range2.value = mode["memory_clocks"]
            label0.textContent = "TDP " + mode["tdp"]
            label1.textContent = "CLOCK " + mode["core_clocks"]
            label2.textContent = "MEMORY " + mode["memory_clocks"]
            setup.appendChild(label0)
            setup.appendChild(range0)
            setup.appendChild(label1)
            setup.appendChild(range1)
            setup.appendChild(label2)
            setup.appendChild(range2)
            setup.insertAdjacentHTML("beforeend", "<br>")
            range0.addEventListener("input", function(e) {
              label0.textContent = "TDP " + range0.value
              mode["tdp"] = parseInt(range0.value)
              element.value = JSON.stringify(json, null, "\t")
            })
            range1.addEventListener("input", function(e) {
              label1.textContent = "CLOCK " + range1.value
              mode["core_clocks"] = parseInt(range1.value)
              element.value = JSON.stringify(json, null, "\t")
            })
            range2.addEventListener("input", function(e) {
              label2.textContent = "MEMORY " + range2.value
              mode["memory_clocks"] = parseInt(range2.value)
              element.value = JSON.stringify(json, null, "\t")
            })
          })
        })
      })
    }

    // Move to top
    top_.addEventListener("click", function() {
      window.scrollTo(0,0)
    })

    // Move to bottom
    bottom.addEventListener("click", function() {
      window.scrollTo(0,document.body.scrollHeight)
    })

    // Clear current logs and loads new ones
    clear.addEventListener("click", function() {
      if (confirm("Are you sure to clear logs in this tab?")) {
        logs.textContent = "Loading new logs"
        dots = setInterval(function() {
          logs.insertAdjacentText("beforeend", ".")
        }, 500)
      }
    })

    // Rig reboot
    reboot.addEventListener("click", function() {
      if (confirm("Are you sure to reboot your rig?")) {
        fetch("http://" + window.location.hostname + ":8082/reboot", {method: "POST"})
          .then(function (response) {return response.text()}).then(function (text) {alert("Reboot executed!")}).catch(function (error) {alert("Error comunicating with local server, reboot probably in progress " + error)})
      }
    })

    // Show or Close OC Settings
    oc.addEventListener("click", async function() {
      if (ocSettings.style.display === "none") {
        if (!confirm("CAUTION: OC can damage your hardware, edit only if you know what you are doing! Do you wanna continue?")) {
          return
        }
        // Two fetch because netcat response can not be edited until next request
        await fetch("http://" + window.location.hostname + ":8082/oc")
        setTimeout(function() {
        fetch("http://" + window.location.hostname + ":8082")
          .then(function (response) {
            return response.text()
          })
          .then(function (text) {
            oc.textContent = "Close OC Settings"
            ocTitle.style.display = "block"
            ocSave.style.display = "inline-block"
            autoscroll.checked = false
            top_.click()
            ocSettings.value = text
            ocSettings.style.display = "block"
            guiSetup(ocSettings)
          })
          .catch(function (error) {
            alert("Error comunicating with local server, reboot probably in progress " + error)
          })
        }, 1000)
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
    ocSave.addEventListener("click", async function() {
      try {
        JSON.parse(ocSettings.value)
      } catch (err) {
        alert("Error in your OC Settings, please check again: " + err)
        return
      }
      // Two fetch because netcat response can not be edited until next request
      await fetch("http://" + window.location.hostname + ":8082/oc", {method: "POST", body: ocSettings.value})
      setTimeout(function() {
      fetch("http://" + window.location.hostname + ":8082")
        .then(function (response) {
          return response.text()
        })
        .then(function (text) {
          if(confirm("Settings saved successfully! Wanna reboot to apply changes?")) {
            reboot.click()
          }
        })
        .catch(function (error) {
          alert("Error saving OC settings in local server, reboot probably in progress " + error)
        })
      }, 1000)
    })

    // Gets Basic Rig information
    rig.insertAdjacentHTML("beforeend", ansi_up.ansi_to_html("`head -1 /var/log/nhos/nhm/*.log`"))
    rig.insertAdjacentHTML("beforeend", "<br>")
    rig.insertAdjacentHTML("beforeend", ansi_up.ansi_to_html("`head -2 /var/log/nhos/nhm/*.log | tail -1`"))

    // Adds Loading and count dots
    logs.insertAdjacentText("beforeend", "Loading")
    dots = setInterval(function() {
      logs.insertAdjacentText("beforeend", ".")
    }, 1000)

    // Connects to Server Sent Events
    new EventSource("http://" + window.location.hostname + ":8081/").onmessage = function(e) {
      // Stop Loading dots
      clearInterval(dots)
      // Limit logs history to 1000 lines
      if (logs.childElementCount > 1000) {
        while (logs.childElementCount > 1000) {
          logs.removeChild(logs.firstChild)
        }
      }
      setTimeout(function() {
        logs.insertAdjacentHTML("beforeend", "<br>")
        logs.insertAdjacentHTML("beforeend", ansi_up.ansi_to_html(e.data))
        // AutoScroll if enabled
        if (autoscroll.checked) {
          window.scrollTo(0,document.body.scrollHeight)
        }
      }, 100)
    }
  </script>
</body>
</html>
HTML
# sss server
ncat -n4 -lk -p 8081 --allow $ALLOW --sh-exec "echo -e 'HTTP/1.1 200 OK\r\nAccess-Control-Allow-Origin: *\r\nContent-type: text/event-stream\r\n'; tail -f /var/log/nhos/nhm/miners/*.log /var/log/nhos/*.log 2>/dev/null | sed -e 's/^/data: /;s/$/\n/'"&
# main server
ncat -n4 -lk -p 80 --allow $ALLOW --sh-exec "echo -e 'HTTP/1.1 200 OK\r\nContent-type: text/html; charset=utf-8\r\nCache-Control: no-cache\r\nX-Content-Type-Options: nosniff\r\n'; echo '$INDEX'"&
# actions server
response="ok"
while sleep 1; do
  echo -e "HTTP/1.1 200 OK\r\nAccess-Control-Allow-Origin: *\r\nAccess-Control-Allow-Methods: GET, POST\r\n\r\n$response" | nc -l -p 8082 > /tmp/actions.log
  cat /tmp/actions.log | grep -q "POST /reboot"
  if [ $? -eq 0 ]; then
    # echo "put reboot"
    response="reboot"
    sudo reboot
  fi
  cat /tmp/actions.log | grep -q "GET /oc"
  if [ $? -eq 0 ]; then
    # echo "get oc"
    if [ -f "/mnt/nhos/nhm/configs/device_settings.json" ]; then
      response=`cat /mnt/nhos/nhm/configs/device_settings.json`
    else
      response="{}"
    fi
  fi
  cat /tmp/actions.log | grep -q "POST /oc"
  if [ $? -eq 0 ]; then
    # echo "post oc"
    chmod +w /mnt/nhos/nhm/configs/device_settings.json
    cat /tmp/actions.log | awk '/{/,0' > /mnt/nhos/nhm/configs/device_settings.json
    chmod -w /mnt/nhos/nhm/configs/device_settings.json
    response=`cat /mnt/nhos/nhm/configs/device_settings.json`
  fi
done
break
fi
done&
