<%@ page masterpagefile="~/template.master" %>
<%@ register tagprefix="build" tagname="addthis" src="/addthis.ascx" %>
<%@ register tagprefix="build" tagname="disqus" src="/disqus.ascx" %>

<asp:content contentplaceholderid="Meta" runat="server">
<title>Play Hold The Line: Zombie Invasion by InFlash Studios</title>
</asp:content>

<asp:content contentplaceholderid="Content" runat="server">

	<div class="box">

		<img class="boxedge" src="/images/boxtop.png" alt="" />

		<div class="boxinner">

			<h1>Play Hold The Line: Zombie Invasion</h1>
	
			<p>A zombie shooter that I'm proud to say was sponsored by <a href="http://www.armorgames.com/">Armor Games</a>.  It got some criticism for using zombies but meh, it's a fun game and it was a lot of fun to make.  Also it's passed a million plays around the internet which is very cool.  :)</p>

			<div class="game">
				
				<script type="text/javascript">
					if (AC_FL_RunContent == 0) {
						alert("This page requires AC_RunActiveContent.js.");
					} else {
						AC_FL_RunContent(
							'codebase', 'http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0',
							'width', '650',
							'height', '300',
							'src', 'holdtheline',
							'quality', 'high',
							'pluginspage', 'http://www.macromedia.com/go/getflashplayer',
							'align', 'middle',
							'play', 'true',
							'loop', 'true',
							'scale', 'showall',
							'wmode', 'transparent',
							'devicefont', 'false',
							'id', 'holdtheline',
							'bgcolor', '#000000',
							'name', 'holdtheline',
							'menu', 'true',
							'allowFullScreen', 'false',
							'allowScriptAccess','sameDomain',
							'movie', 'holdtheline',
							'salign', ''
							); //end AC code
					}
				</script>

			</div>

			<build:addthis runat="server" />

		</div>

		<img class="boxedge" src="/images/boxbottom.png" alt="" />

	</div>

	<div class="box">

		<img class="boxedge" src="/images/boxtop.png" alt="" />

		<div class="boxinner">

			<h2>Download</h2>
			<ul>
				<li><a href="/holdtheline/holdtheline.zip">Download Hold The Line: Zombie Invasion + screenshots and thumbnails for your website</a></li>
				<li><a href="/holdtheline/holdtheline_IPBArcade.zip">IPBArcade version of Hold The Line: Zombie Invasion + screenshots and thumbnails for your website</a></li>
			</ul>

			<h2>Add Hold The Line: Zombie Invasion to your site</h2>

			<textarea class="embed" onclick="this.select();" rows="5" cols="25">&lt;object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553530000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0" width="650" height="300" id="holdtheline" align="middle"&gt;
&lt;param name="allowScriptAccess" value="sameDomain" /&gt;
&lt;param name="allowFullScreen" value="false" /&gt;
&lt;param name="movie" value="http://www.inflashstudios.com/holdtheline/holdtheline.swf" /&gt;&lt;param name="quality" value="high" /&gt;&lt;param name="wmode" value="transparent" /&gt;&lt;param name="bgcolor" value="#000000" /&gt;	&lt;embed src="http://www.inflashstudios.com/holdtheline/holdtheline.swf" quality="high" wmode="transparent" bgcolor="#000000" width="650" height="300" name="holdtheline" align="middle" allowScriptAccess="sameDomain" allowFullScreen="false" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" /&gt;
&lt;/object&gt;
&lt;a href="http://www.inflashstudios.com/holdtheline/default.aspx"&gt;Get Hold The Line&lt;/a&gt;</textarea>

		</div>

		<img class="boxedge" src="/images/boxbottom.png" alt="" />

	</div>

	<div class="box">

		<img class="boxedge" src="/images/boxtop.png" alt="" />

		<div class="boxinner">

			<build:disqus runat="server" />

		</div>

		<img class="boxedge" src="/images/boxbottom.png" alt="" />
	
	</div>

</asp:content>