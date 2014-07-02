// JavaScript Document
var Sys = {};
var ua = navigator.userAgent.toLowerCase();
window.ActiveXObject ? Sys.ie = ua.match(/msie ([\d.]+)/)[1] :
document.getBoxObjectFor ? Sys.firefox = ua.match(/firefox\/([\d.]+)/)[1] :
window.MessageEvent && !document.getBoxObjectFor ? Sys.chrome = ua.match(/chrome\/([\d.]+)/)[1] :
window.opera ? Sys.opera = ua.match(/opera.([\d.]+)/)[1] :
window.openDatabase ? Sys.safari = ua.match(/version\/([\d.]+)/)[1] : 0;