/*jslint browser: true */
/*global ActiveXObject */

function createXMLHttpRequest() {
  try {
    return new XMLHttpRequest();
  } catch (e1) {}
  try {
    return new ActiveXObject("Msxml2.XMLHTTP");
  } catch (e2) {}
  try {
    return new ActiveXObject("Microsoft.XMLHTTP");
  } catch (e3) {}
  alert("XMLHttpRequest not supported");
  return null;
}

function key_input(e) {
  var keynum;

  if (!e) { // IE Nonsense
    e = window.event;
  }

  keynum = e.charCode ? e.charCode :
           e.keyCode  ? e.keyCode  :
           e.which    ? e.which    : 0;

  if (keynum === 13) {
    var xhReq = createXMLHttpRequest();
    var qry = this.name + "=" + this.value;
    var url =  "http://politicalweb.org.uk/api/constituency/?fmt=html;" + qry;
    xhReq.open("GET", url, true);
    xhReq.onreadystatechange = function () {
      if (xhReq.readyState !== 4) {
        return;
      }
      var html = xhReq.responseText;
      document.getElementById("result").innerHTML = html;
    };
    xhReq.send(null);
    return false;
  }
}

window.onload = function () {
  document.getElementById('pc').onkeypress = key_input;
  document.getElementById('name').onkeypress = key_input;
};

