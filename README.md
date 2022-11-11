# Spyglass

<img width="1002" alt="Screen Shot 2022-11-11 at 13 25 06" src="https://user-images.githubusercontent.com/12128692/201277176-7159683f-cdab-4c4a-8f50-d7f3a2936af2.png">

## What?
Debugging tool for an event-driven application  
  
## Why?
* Can't debug events without IDE 
* iOS debugger is slow
* To change the state, need to modify the source code 

## How it works?
* Spyglass starts a websocket 
* Mobile client connects to the server
* Every time event engine receives an event, it should send it via websocket to Spyglass 
* Every time Spyglass changes state, it could send the new state to the mobile client 

## How to use?
* Open Spyglass application 
* Select either localhost (used to connect iOS/Android simulators to Spyglass) or IP address of your machine
* Open application with Spyglass client
* Enjoy debugging!!!

## How to install
* Use the command to build Spyglass from the source code
```
curl https://raw.githubusercontent.com/uncle-alek/Spyglass/main/spyglass_installer.sh | sh
```
* Use the releases of the repository to download the archive with the binary
```
https://github.com/uncle-alek/Spyglass/releases
```
