$(document).ready(function(){
/*  $("#post_preview").bind("click", function(){
		// get the values from the page
		var title = $('input#post_title').val();
		var body = $('textarea#post_body').val();
		
		$.post("/admin/posts/post_preview", { authenticity_token: window._token, post_title: title, post_body: body },
			function(html) {
				openPopUp(html, 'postpreview');
			});

		return false;
	});
*/
});

function openPopUp(html, windowName){
	var preview = window.open('', windowName);

	preview.document.open();
	preview.document.write(html);
	preview.document.close();
};
