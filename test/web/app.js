function httpRequest(address, reqType) {
    var req = new XMLHttpRequest();
    req.open(reqType, address, false);
    req.send();
    return req;
}

function getAuthorization()
{
    var cookies =  new URLSearchParams(document.cookie);
    if(cookies.has("token"))
        return "Basic " + btoa('token:' + new URLSearchParams(document.cookie).get("token"));
    return "";
}