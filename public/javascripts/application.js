$(document).ready(function(){
  $("#post_preview").bind("click", function(){
		$.post("/admin/posts/foo/post_preview", { authenticity_token: window._token, post_title: "Test", post_body: "Some text" } );
		var preview = window.open('about:blank','postpreview');

		var html = "<html><head></head><body>Hello World</body></html>";
		// put in nice method
		preview.document.open();
		preview.document.write(html);
		preview.document.close();
		return false;
	});
});
