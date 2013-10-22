<#include "/org/alfresco/enterprise/repository/admin/admin-template.ftl" />

<@page title=msg("alfresco-threaddump.title") readonly=true>

<div class="column-full">
    <p class="intro">${msg("alfresco-threaddump.intro-text")?html}</p>
     
	<input type="button" value="Get another ThreadDump!" onclick="getdump();" >
	<input type="button" value="Save All" onclick='saveTextAsFile("viewer");' > 
	<hr>
	<div id="control">
		<input type="button" value="0" class="selector" id="sif0" onclick="ShowiFrame('if0');" >
	</div>
	<div id="viewer"  style="
            overflow: hidden;
            resize: both;
			height:768px;
			width:1024px;
            " >
		<iframe id="if0" class="thread" src="/alfresco/s/enterprise/admin/admin-alfresco-threaddump-getone" frameborder="1" height=97% width=97% scrolling="auto" style="display: block;" ></iframe></div>
	</div>
</div>


<script type="text/javascript">//<![CDATA[

    function saveTextAsFile(tosave){
		var textToWrite = "";
		var allframes = document.getElementsByClassName ('thread');
	    for (var i = 0; i < allframes.length; i++) {
			var oIframe = allframes[i] ;
			var oDoc = (oIframe.contentWindow || oIframe.contentDocument);
			if (oDoc.document) oDoc = oDoc.document;
	        textToWrite =textToWrite + oDoc.body.textContent +"\n";
			};
		var textFileAsBlob = new Blob([textToWrite], {type:'text/plain'});
		var fileNameToSaveAs = "threaddump.txt";

		var downloadLink = document.createElement("a");
		downloadLink.download = fileNameToSaveAs;
		downloadLink.innerHTML = "Download File";
		if (window.webkitURL != null)
		{
			// Chrome allows the link to be clicked
			// without actually adding it to the DOM.
			downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
		}
		else
		{
			// Firefox requires the link to be added to the DOM
			// before it can be clicked.
			downloadLink.href = window.URL.createObjectURL(textFileAsBlob);
			//downloadLink.onclick = destroyClickedElement;
			downloadLink.style.display = "none";
			document.body.appendChild(downloadLink);
		}

		downloadLink.click();
	}

	var counter=0;

	function ShowiFrame(iframeName){
	 allframes = document.getElementsByClassName ('thread');
	 for (var i = 0; i < allframes.length; i++) {
	  if (allframes[i].id==iframeName){
	   allframes[i].style.display="block";
	  }
	  else {
	   allframes[i].style.display="none";
	  }
	 }
	 selectors = document.getElementsByClassName ('selector');
	 for (var i = 0; i < selectors.length; i++) {
	  if (selectors[i].id=="s"+iframeName){
	   selectors[i].style.backgroundColor="#0000EE";
	  }
	  else {
	   selectors[i].style.backgroundColor="#6E9E2D";
	  }
	 }
	}
	function getdump(){
	 counter=counter+1;
	 viewer = document.getElementById ('viewer');
	 control = document.getElementById ('control');
	 
	 viewer.innerHTML=viewer.innerHTML +' <iframe id="if'+counter+'" class="thread" src="/alfresco/s/enterprise/admin/admin-alfresco-threaddump-getone" frameborder="1" height=97% width=97% scrolling="auto" style="display: block;"></iframe></div>';
	 control.innerHTML=control.innerHTML +' <input type="button" class="selector" value="'+counter+'" id="sif'+counter+'" onclick="ShowiFrame('+ "'if"+counter+"'"+');" >';
	 ShowiFrame('if'+counter)
	}
//]]></script>


</@page>



