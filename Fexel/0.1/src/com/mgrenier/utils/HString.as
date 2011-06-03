package com.mgrenier.utils {
	import flash.utils.Dictionary;
	/**
	* 	Modified by Michael Grenier, 1 September 2009
	*	String Utilities class by Ryan Matsikas, Feb 10 2006
	*
	*	Visit www.gskinner.com for documentation, updates and more free code.
	* 	You may distribute this code freely, as long as this comment block remains intact.
	*/

	public class HString {

		/**
		*	Returns everything after the first occurrence of the provided character in the string.
		*
		*	@param p_string The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function afterFirst(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.indexOf(p_char);
			if (idx == -1) { return ''; }
			idx += p_char.length;
			return p_string.substr(idx);
		}

		/**
		*	Returns everything after the last occurence of the provided character in p_string.
		*
		*	@param p_string The string.
		*
		*	@param p_char The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function afterLast(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.lastIndexOf(p_char);
			if (idx == -1) { return ''; }
			idx += p_char.length;
			return p_string.substr(idx);
		}

		/**
		*	Determines whether the specified string begins with the specified prefix.
		*
		*	@param p_string The string that the prefix will be checked against.
		*
		*	@param p_begin The prefix that will be tested against the string.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function beginsWith(p_string:String, p_begin:String):Boolean {
			if (p_string == null) { return false; }
			return p_string.indexOf(p_begin) == 0;
		}

		/**
		*	Returns everything before the first occurrence of the provided character in the string.
		*
		*	@param p_string The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function beforeFirst(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.indexOf(p_char);
        	if (idx == -1) { return ''; }
        	return p_string.substr(0, idx);
		}

		/**
		*	Returns everything before the last occurrence of the provided character in the string.
		*
		*	@param p_string The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function beforeLast(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.lastIndexOf(p_char);
        	if (idx == -1) { return ''; }
        	return p_string.substr(0, idx);
		}

		/**
		*	Returns everything after the first occurance of p_start and before
		*	the first occurrence of p_end in p_string.
		*
		*	@param p_string The string.
		*
		*	@param p_start The character or sub-string to use as the start index.
		*
		*	@param p_end The character or sub-string to use as the end index.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function between(p_string:String, p_start:String, p_end:String):String {
			var str:String = '';
			if (p_string == null) { return str; }
			var startIdx:int = p_string.indexOf(p_start);
			if (startIdx != -1) {
				startIdx += p_start.length; // RM: should we support multiple chars? (or ++startIdx);
				var endIdx:int = p_string.indexOf(p_end, startIdx);
				if (endIdx != -1) { str = p_string.substr(startIdx, endIdx-startIdx); }
			}
			return str;
		}

		/**
		*	Description, Utility method that intelligently breaks up your string,
		*	allowing you to create blocks of readable text.
		*	This method returns you the closest possible match to the p_delim paramater,
		*	while keeping the text length within the p_len paramter.
		*	If a match can't be found in your specified length an  '...' is added to that block,
		*	and the blocking continues untill all the text is broken apart.
		*
		*	@param p_string The string to break up.
		*
		*	@param p_len Maximum length of each block of text.
		*
		*	@param p_delim delimter to end text blocks on, default = '.'
		*
		*	@returns Array
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function block(p_string:String, p_len:uint, p_delim:String = "."):Array {
			var arr:Array = new Array();
			if (p_string == null || !contains(p_string, p_delim)) { return arr; }
			var chrIndex:uint = 0;
			var strLen:uint = p_string.length;
			var replPatt:RegExp = new RegExp("[^"+escapePattern(p_delim)+"]+$");
			while (chrIndex <  strLen) {
				var subString:String = p_string.substr(chrIndex, p_len);
				if (!contains(subString, p_delim)){
					arr.push(truncate(subString, subString.length));
					chrIndex += subString.length;
				}
				subString = subString.replace(replPatt, '');
				arr.push(subString);
				chrIndex += subString.length;
			}
			return arr;
		}

		/**
		*	Capitallizes the first word in a string or all words..
		*
		*	@param p_string The string.
		*
		*	@param p_all (optional) Boolean value indicating if we should
		*	capitalize all words or only the first.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function capitalize(p_string:String, ...args):String {
			var str:String = trimLeft(p_string);
			trace('capl', args[0])
			if (args[0] === true) { return str.replace(/^.|\b./g, _upperCase);}
			else { return str.replace(/(^\w)/, _upperCase); }
		}

		/**
		*	Determines whether the specified string contains any instances of p_char.
		*
		*	@param p_string The string.
		*
		*	@param p_char The character or sub-string we are looking for.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function contains(p_string:String, p_char:String):Boolean {
			if (p_string == null) { return false; }
			return p_string.indexOf(p_char) != -1;
		}

		/**
		*	Determines the number of times a charactor or sub-string appears within the string.
		*
		*	@param p_string The string.
		*
		*	@param p_char The character or sub-string to count.
		*
		*	@param p_caseSensitive (optional, default is true) A boolean flag to indicate if the
		*	search is case sensitive.
		*
		*	@returns uint
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function countOf(p_string:String, p_char:String, p_caseSensitive:Boolean = true):uint {
			if (p_string == null) { return 0; }
			var char:String = escapePattern(p_char);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.match(new RegExp(char, flags)).length;
		}
		
		import flash.xml.XMLDocument;
		
		/**
		 * 	Decode html entities
		 * 	
		 * 	@param p_string The source string.
		 * 
		 * 	@returns String
		 */
		public static function decodeHTMLEntitites (p_string:String):String
		{
			var entities:Object = {"&euro;":"&#8364;","&rsaquo;":"&#8250;","&lsaquo;":"&#8249;","&permil;":"&#8240;","&Dagger;":"&#8225;","&dagger;":"&#8224;","&bdquo;":"&#8222;","&rdquo;":"&#8221;","&ldquo;":"&#8220;","&sbquo;":"&#8218;","&rsquo;":"&#8217;","&lsquo;":"&#8216;","&mdash;":"&#8212;","&ndash;":"&#8211;","&rlm;":"&#8207;","&lrm;":"&#8206;","&zwj;":"&#8205;","&zwnj;":"&#8204;","&thinsp;":"&#8201;","&emsp;":"&#8195;","&ensp;":"&#8194;","&tilde;":"&#732;","&circ;":"&#710;","&Yuml;":"&#376;","&scaron;":"&#353;","&Scaron;":"&#352;","&oelig;":"&#339;","&OElig;":"&#338;",">":"&#62;","<":"&#60;","\"":"&#34;","&diams;":"&#9830;","&hearts;":"&#9829;","&clubs;":"&#9827;","&spades;":"&#9824;","&loz;":"&#9674;","&rang;":"&#9002;","&lang;":"&#9001;","&rfloor;":"&#8971;","&lfloor;":"&#8970;","&rceil;":"&#8969;","&lceil;":"&#8968;","&sdot;":"&#8901;","&perp;":"&#8869;","&otimes;":"&#8855;","&oplus;":"&#8853;","&supe;":"&#8839;","&sube;":"&#8838;","&nsub;":"&#8836;","&sup;":"&#8835;","&sub;":"&#8834;","&ge;":"&#8805;","&le;":"&#8804;","&equiv;":"&#8801;","&ne;":"&#8800;","&asymp;":"&#8776;","&cong;":"&#8773;","&sim;":"&#8764;","&there4;":"&#8756;","&int;":"&#8747;","&cup;":"&#8746;","&cap;":"&#8745;","&or;":"&#8744;","&and;":"&#8743;","&ang;":"&#8736;","&infin;":"&#8734;","&prop;":"&#8733;","&radic;":"&#8730;","&lowast;":"&#8727;","&minus;":"&#8722;","&sum;":"&#8721;","&prod;":"&#8719;","&ni;":"&#8715;","&notin;":"&#8713;","&isin;":"&#8712;","&nabla;":"&#8711;","&empty;":"&#8709;","&exist;":"&#8707;","&part;":"&#8706;","&forall;":"&#8704;","&hArr;":"&#8660;","&dArr;":"&#8659;","&rArr;":"&#8658;","&uArr;":"&#8657;","&lArr;":"&#8656;","&crarr;":"&#8629;","&harr;":"&#8596;","&darr;":"&#8595;","&rarr;":"&#8594;","&uarr;":"&#8593;","&larr;":"&#8592;","&alefsym;":"&#8501;","&trade;":"&#8482;","&real;":"&#8476;","&image;":"&#8465;","&weierp;":"&#8472;","&frasl;":"&#8260;","&oline;":"&#8254;","&Prime;":"&#8243;","&prime;":"&#8242;","&hellip;":"&#8230;","&bull;":"&#8226;","&piv;":"&#982;","&upsih;":"&#978;","&thetasym;":"&#977;","&omega;":"&#969;","&psi;":"&#968;","&chi;":"&#967;","&phi;":"&#966;","&upsilon;":"&#965;","&tau;":"&#964;","&sigma;":"&#963;","&sigmaf;":"&#962;","&rho;":"&#961;","&pi;":"&#960;","&omicron;":"&#959;","&xi;":"&#958;","&nu;":"&#957;","&mu;":"&#956;","&lambda;":"&#955;","&kappa;":"&#954;","&iota;":"&#953;","&theta;":"&#952;","&eta;":"&#951;","&zeta;":"&#950;","&epsilon;":"&#949;","&delta;":"&#948;","&gamma;":"&#947;","&beta;":"&#946;","&alpha;":"&#945;","&Omega;":"&#937;","&Psi;":"&#936;","&Chi;":"&#935;","&Phi;":"&#934;","&Upsilon;":"&#933;","&Tau;":"&#932;","&Sigma;":"&#931;","&Rho;":"&#929;","&Pi;":"&#928;","&Omicron;":"&#927;","&Xi;":"&#926;","&Nu;":"&#925;","&Mu;":"&#924;","&Lambda;":"&#923;","&Kappa;":"&#922;","&Iota;":"&#921;","&Theta;":"&#920;","&Eta;":"&#919;","&Zeta;":"&#918;","&Epsilon;":"&#917;","&Delta;":"&#916;","&Gamma;":"&#915;","&Beta;":"&#914;","&Alpha;":"&#913;","&fnof;":"&#402;","&yuml;":"&#255;","&thorn;":"&#254;","&yacute;":"&#253;","&uuml;":"&#252;","&ucirc;":"&#251;","&uacute;":"&#250;","&ugrave;":"&#249;","&oslash;":"&#248;","&divide;":"&#247;","&ouml;":"&#246;","&otilde;":"&#245;","&ocirc;":"&#244;","&oacute;":"&#243;","&ograve;":"&#242;","&ntilde;":"&#241;","&eth;":"&#240;","&iuml;":"&#239;","&icirc;":"&#238;","&iacute;":"&#237;","&igrave;":"&#236;","&euml;":"&#235;","&ecirc;":"&#234;","&eacute;":"&#233;","&egrave;":"&#232;","&ccedil;":"&#231;","&aelig;":"&#230;","&aring;":"&#229;","&auml;":"&#228;","&atilde;":"&#227;","&acirc;":"&#226;","&aacute;":"&#225;","&agrave;":"&#224;","&szlig;":"&#223;","&THORN;":"&#222;","&Yacute;":"&#221;","&Uuml;":"&#220;","&Ucirc;":"&#219;","&Uacute;":"&#218;","&Ugrave;":"&#217;","&Oslash;":"&#216;","&times;":"&#215;","&Ouml;":"&#214;","&Otilde;":"&#213;","&Ocirc;":"&#212;","&Oacute;":"&#211;","&Ograve;":"&#210;","&Ntilde;":"&#209;","&ETH;":"&#208;","&Iuml;":"&#207;","&Icirc;":"&#206;","&Iacute;":"&#205;","&Igrave;":"&#204;","&Euml;":"&#203;","&Ecirc;":"&#202;","&Eacute;":"&#201;","&Egrave;":"&#200;","&Ccedil;":"&#199;","&AElig;":"&#198;","&Aring;":"&#197;","&Auml;":"&#196;","&Atilde;":"&#195;","&Acirc;":"&#194;","&Aacute;":"&#193;","&Agrave;":"&#192;","&iquest;":"&#191;","&frac34;":"&#190;","&frac12;":"&#189;","&frac14;":"&#188;","&raquo;":"&#187;","&ordm;":"&#186;","&sup1;":"&#185;","&cedil;":"&#184;","&middot;":"&#183;","&para;":"&#182;","&micro;":"&#181;","&acute;":"&#180;","&sup3;":"&#179;","&sup2;":"&#178;","&plusmn;":"&#177;","&deg;":"&#176;","&macr;":"&#175;","&reg;":"&#174;","&shy;":"&#173;","&not;":"&#172;","&laquo;":"&#171;","&ordf;":"&#170;","&copy;":"&#169;","&uml;":"&#168;","&sect;":"&#167;","&brvbar;":"&#166;","&yen;":"&#165;","&curren;":"&#164;","&pound;":"&#163;","&cent;":"&#162;","&iexcl;":"&#161;","&nbsp;":"&#160;"};
			p_string = replace(p_string, entities, 'g').split("&#38;").join("&")
			return new XMLDocument(p_string).firstChild.nodeValue;
		}

		/**
		*	Levenshtein distance (editDistance) is a measure of the similarity between two strings,
		*	The distance is the number of deletions, insertions, or substitutions required to
		*	transform p_source into p_target.
		*
		*	@param p_source The source string.
		*
		*	@param p_target The target string.
		*
		*	@returns uint
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function editDistance(p_source:String, p_target:String):uint {
			var i:uint;

			if (p_source == null) { p_source = ''; }
			if (p_target == null) { p_target = ''; }

			if (p_source == p_target) { return 0; }

			var d:Array = new Array();
			var cost:uint;
			var n:uint = p_source.length;
			var m:uint = p_target.length;
			var j:uint;

			if (n == 0) { return m; }
			if (m == 0) { return n; }

			for (i=0; i<=n; i++) { d[i] = new Array(); }
			for (i=0; i<=n; i++) { d[i][0] = i; }
			for (j=0; j<=m; j++) { d[0][j] = j; }

			for (i=1; i<=n; i++) {

				var s_i:String = p_source.charAt(i-1);
				for (j=1; j<=m; j++) {

					var t_j:String = p_target.charAt(j-1);

					if (s_i == t_j) { cost = 0; }
					else { cost = 1; }

					d[i][j] = _minimum(d[i-1][j]+1, d[i][j-1]+1, d[i-1][j-1]+cost);
				}
			}
			return d[n][m];
		}

		/**
		*	Determines whether the specified string ends with the specified suffix.
		*
		*	@param p_string The string that the suffic will be checked against.
		*
		*	@param p_end The suffix that will be tested against the string.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function endsWith(p_string:String, p_end:String):Boolean {
			return p_string.lastIndexOf(p_end) == p_string.length - p_end.length;
		}

		/**
		*	Determines whether the specified string contains text.
		*
		*	@param p_string The string to check.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function hasText(p_string:String):Boolean {
			var str:String = removeExtraWhitespace(p_string);
			return !!str.length;
		}

		/**
		*	Determines whether the specified string contains any characters.
		*
		*	@param p_string The string to check
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function isEmpty(p_string:String):Boolean {
			if (p_string == null) { return true; }
			return !p_string.length;
		}

		/**
		*	Determines whether the specified string is numeric.
		*
		*	@param p_string The string.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function isNumeric(p_string:String):Boolean {
			if (p_string == null) { return false; }
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test(p_string);
		}

		/**
		* Pads p_string with specified character to a specified length from the left.
		*
		*	@param p_string String to pad
		*
		*	@param p_padChar Character for pad.
		*
		*	@param p_length Length to pad to.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function padLeft(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) { s = p_padChar + s; }
			return s;
		}

		/**
		* Pads p_string with specified character to a specified length from the right.
		*
		*	@param p_string String to pad
		*
		*	@param p_padChar Character for pad.
		*
		*	@param p_length Length to pad to.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function padRight(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) { s += p_padChar; }
			return s;
		}

		/**
		*	Printf support for AS3
		* 
		*	@see com.mgrenier.utils.printf for more details
		*	@param p_string The String to be substituted
		*	@param rest The objects to be substitued   
		*/
		public static function printf (p_string:String, ...rest):String
		{
			return com.mgrenier.utils.printf(p_string, rest);
		}

		/**
		*	Properly cases' the string in "sentence format".
		*
		*	@param p_string The string to check
		*
		*	@returns String.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function properCase(p_string:String):String {
			if (p_string == null) { return ''; }
			var str:String = p_string.toLowerCase().replace(/\b([^.?;!]+)/, capitalize);
			return str.replace(/\b[i]\b/, "I");
		}

		/**
		*	Escapes all of the characters in a string to create a friendly "quotable" sting
		*
		*	@param p_string The string that will be checked for instances of remove
		*	string
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function quote(p_string:String):String {
			var regx:RegExp = /[\\"\r\n]/g;
			return '"'+ p_string.replace(regx, _quote) +'"'; //"
		}

		/**
		*	Removes all instances of the remove string in the input string.
		*
		*	@param p_string The string that will be checked for instances of remove
		*	string
		*
		*	@param p_remove The string that will be removed from the input string.
		*
		*	@param p_caseSensitive An optional boolean indicating if the replace is case sensitive. Default is true.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function remove(p_string:String, p_remove:String, p_caseSensitive:Boolean = true):String {
			if (p_string == null) { return ''; }
			var rem:String = escapePattern(p_remove);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.replace(new RegExp(rem, flags), '');
		}

		/**
		*	Removes extraneous whitespace (extra spaces, tabs, line breaks, etc) from the
		*	specified string.
		*
		*	@param p_string The String whose extraneous whitespace will be removed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function removeExtraWhitespace(p_string:String):String {
			if (p_string == null) { return ''; }
			var str:String = trim(p_string);
			return str.replace(/\s+/g, ' ');
		}
		
		/**
		*	Replace string using Array
		* 	
		*	@param p_string The String that will be search
		*	@param p_replace The Object pair
		*	@returns String 
		*/ 
		public static function replace(p_string:String, p_replace:Object, flag:String = "s"):String {
			if (p_string == null) { return ''; }
			var pattern:RegExp;
			
			switch(typeof p_replace)
			{
				case 'xml':
					for each (var xml:XML in p_replace.children())
					{
						pattern = new RegExp(xml.name(), flag);
						p_string = p_string.replace(pattern, xml.toString());
					}
					break;
				case 'object':
					for (var key:String in p_replace)
					{
						pattern = new RegExp(key, flag);
						p_string = p_string.replace(pattern, p_replace[key]);
					}
					break;
				default:
					return p_string;
			}
			
			return p_string;
		}
		
		/**
		*	Returns the specified string in reverse character order.
		*
		*	@param p_string The String that will be reversed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function reverse(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.split('').reverse().join('');
		}

		/**
		*	Returns the specified string in reverse word order.
		*
		*	@param p_string The String that will be reversed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function reverseWords(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.split(/\s+/).reverse().join('');
		}

		/**
		*	Determines the percentage of similiarity, based on editDistance
		*
		*	@param p_source The source string.
		*
		*	@param p_target The target string.
		*
		*	@returns Number
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function similarity(p_source:String, p_target:String):Number {
			var ed:uint = editDistance(p_source, p_target);
			var maxLen:uint = Math.max(p_source.length, p_target.length);
			if (maxLen == 0) { return 100; }
			else { return (1 - ed/maxLen) * 100; }
		}

		/**
		*	Remove's all < and > based tags from a string
		*
		*	@param p_string The source string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function stripTags(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/<\/?[^>]+>/igm, '');
		}

		/**
		*	Swaps the casing of a string.
		*
		*	@param p_string The source string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function swapCase(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/(\w)/, _swapCase);
		}

		/**
		*	Removes whitespace from the front and the end of the specified
		*	string.
		*
		*	@param p_string The String whose beginning and ending whitespace will
		*	will be removed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function trim(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/^\s+|\s+$/g, '');
		}

		/**
		*	Removes whitespace from the front (left-side) of the specified string.
		*
		*	@param p_string The String whose beginning whitespace will be removed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function trimLeft(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/^\s+/, '');
		}

		/**
		*	Removes whitespace from the end (right-side) of the specified string.
		*
		*	@param p_string The String whose ending whitespace will be removed.
		*
		*	@returns String	.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function trimRight(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/\s+$/, '');
		}

		/**
		*	Determins the number of words in a string.
		*
		*	@param p_string The string.
		*
		*	@returns uint
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function wordCount(p_string:String):uint {
			if (p_string == null) { return 0; }
			return p_string.match(/\b\w+\b/g).length;
		}

		/**
		*	Returns a string truncated to a specified length with optional suffix
		*
		*	@param p_string The string.
		*
		*	@param p_len The length the string should be shortend to
		*
		*	@param p_suffix (optional, default=...) The string to append to the end of the truncated string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function truncate(p_string:String, p_len:uint, p_suffix:String = "..."):String {
			if (p_string == null) { return ''; }
			p_len -= p_suffix.length;
			var trunc:String = p_string;
			if (trunc.length > p_len) {
				trunc = trunc.substr(0, p_len);
				if (/[^\s]/.test(p_string.charAt(p_len))) {
					trunc = trimRight(trunc.replace(/\w+$|\s+$/, ''));
				}
				trunc += p_suffix;
			}

			return trunc;
		}

		/* **************************************************************** */
		/*	These are helper methods used by some of the above methods.		*/
		/* **************************************************************** */
		private static function escapePattern(p_pattern:String):String {
			// RM: might expose this one, I've used it a few times already.
			return p_pattern.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, '\\$1');
		}

		private static function _minimum(a:uint, b:uint, c:uint):uint {
			return Math.min(a, Math.min(b, Math.min(c,a)));
		}

		private static function _quote(p_string:String, ...args):String {
			switch (p_string) {
				case "\\":
					return "\\\\";
				case "\r":
					return "\\r";
				case "\n":
					return "\\n";
				case '"':
					return '\\"';
				default:
					return '';
			}
		}

		private static function _upperCase(p_char:String, ...args):String {
			trace('cap latter ',p_char)
			return p_char.toUpperCase();
		}

		private static function _swapCase(p_char:String, ...args):String {
			var lowChar:String = p_char.toLowerCase();
			var upChar:String = p_char.toUpperCase();
			switch (p_char) {
				case lowChar:
					return upChar;
				case upChar:
					return lowChar;
				default:
					return p_char;
			}
		}

	}
}

/*import com.mgrenier.utils.HString;
String.prototype.afterFirst = function (p_char:String):String { return HString.afterFirst(this, p_char); };
String.prototype.afterLast = function (p_char:String):String { return HString.afterLast(this, p_char); };
String.prototype.beginsWith = function (p_begin:String):Boolean { return HString.beginsWith(this, p_begin); };
String.prototype.beforeFirst = function (p_char:String):String { return HString.beforeFirst(this, p_char); };
String.prototype.beforeLast = function (p_char:String):String { return HString.beforeLast(this, p_char); };
String.prototype.between = function (p_start:String, p_end:String):String { return HString.between(this, p_start, p_end); };
String.prototype.block = function (p_len:uint, p_delim:String = "."):Array { return HString.block(this, p_len, p_delim); };
String.prototype.capitalize = function (p_all:Boolean):String { return HString.capitalize(this, p_all); };
String.prototype.contains = function (p_char:String):Boolean { return HString.contains(this, p_char); };
String.prototype.countOf = function (p_char:String, p_caseSensitive:Boolean = true):uint { return HString.countOf(this, p_char, p_caseSensitive); };
String.prototype.editDistance = function (p_target:String):uint { return HString.editDistance(this, p_target); };
String.prototype.endsWith = function (p_end:String):Boolean { return HString.endsWith(this, p_end); };
String.prototype.hasText = function ():Boolean { return HString.hasText(this); };
String.prototype.isEmpty = function ():Boolean { return HString.isEmpty(this); };
String.prototype.isNumeric = function ():Boolean { return HString.isNumeric(this); };
String.prototype.padLeft = function (p_padChar:String, p_length:uint):String { return HString.padLeft(this, p_padChar, p_length); };
String.prototype.padRight = function (p_padChar:String, p_length:uint):String { return HString.padRight(this, p_padChar, p_length); };
String.prototype.properCase = function ():String { return HString.properCase(this); };
String.prototype.quote = function ():String { return HString.quote(this); };
String.prototype.remove = function (p_remove:String, p_caseSensitive:Boolean = true):String { return HString.remove(this, p_remove, p_caseSensitive); };
String.prototype.removeExtraWhitespace = function ():String { return HString.removeExtraWhitespace(this); };
String.prototype.reverse = function ():String { return HString.reverse(this); };
String.prototype.reverseWords = function ():String { return HString.reverseWords(this); };
String.prototype.similarity = function (p_target:String):HString { return HString.similarity(this, p_target); };
String.prototype.stripTags = function ():String { return HString.stripTags(this); };
String.prototype.swapCase = function ():String { return HString.swapCase(this); };
String.prototype.trim = function ():String { return HString.trim(this); };
String.prototype.trimLeft = function ():String { return HString.trimLeft(this); };
String.prototype.trimRight = function ():String { return HString.trimRight(this); };
String.prototype.truncate = function (p_len:uint, p_suffix:String):String { return HString.truncate(this, p_len, p_suffix); };
String.prototype.wordCount = function ():uint { return HString.wordCount(this); };*/