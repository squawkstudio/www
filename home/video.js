function onVideoClick(theLink) {
  document.getElementById("video_pop").innerHTML = '<video autoplay id="the_Video" src="' + theLink + '"></video>';
  document.getElementById("video_pop").style.display = "block";
}

function onPopClick() {
  document.getElementById("video_pop").style.display = "none";
  document.getElementById("video_pop").innerHTML = "";
}
