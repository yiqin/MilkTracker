// AGENT CODE
 // Log the URLs we need
server.log("Open " + http.agenturl());


function startTime(time)
{
    // Send the device a 'pong' message immediately
    
    server.log("Receive this message from the device "+time);
    
    post(time)
}
 
// When we get a 'ping' message from the device, call start_time()
 
device.on("ping", startTime); 





const PARSE_URL = "https://api.parse.com//1/classes/MilkValue"

function processResponse(incomingDataTable) 
{
    // This is the completed-request callback function. It logs the
    // incoming response's message and status code
    
    server.log("Code: " + incomingDataTable.statuscode + ". Message: " + incomingDataTable.body)
}

function post(value)
{
    // Send HTTP Request...
    
    local body = http.jsonencode({ message = value })
    local extraHeaders = {"X-Parse-Application-Id":"mOcHUeQvTJtt6CEOSrL8NMqhvJaI2TlUEvyjcfoK", "X-Parse-REST-API-Key":"rPdUfI6m5CBFrX6ueQ5mmpe0T0pCVLLzyp5uFQLi","Content-Type":"application/json"}
    local request = http.post(PARSE_URL, extraHeaders, body)
    
    request.sendasync(processResponse) 
    
}
