applicationCache = applicationCache || {};

applicationCache.onupdateready = function() {
  document.body.innerHTML = "app cache updated. will reload.";
  if (window.applicationCache.status === window.applicationCache.UPDATEREADY) {
    window.applicationCache.swapCache();
    setTimeout( function(){
    	window.location.reload();
    },100) 
  }
};

applicationCache.onobsolete = function(){
	document.body.innerHTML = "app cache obsolete. will update.";
	window.applicationCache.update();
};
