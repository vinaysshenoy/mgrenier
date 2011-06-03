package com.mgrenier.utils
{
	import flash.text.TextFormat;

	public class HTextFormat
	{
		/**
		 * Parse style string's
		 * 
		 * @param String style
		 * @return TextFormat
		 */
		static public function parseStyle (styleString:String):TextFormat
		{
			var format:TextFormat = new TextFormat();
			
			var styles:Array = styleString.split(';');
			
			for each(var style:String in styles)
			{
				var property:Array = style.split(':');
				if (property.length == 2)
				{
					switch (property[0])
					{
						case 'align':
						case 'font':
						case 'target':
						case 'url':
							format[property[0]] = String(property[1]);
							break;
						case 'color':
							property[1] = String(property[1]).replace(/[#]/g, '0x');
						case 'blockIndent':
						case 'indent':
						case 'leading':
						case 'leftMargin':
						case 'letterSpacing':
						case 'rightMargin':
						case 'size':
							format[property[0]] = int(property[1]);
							break;
						case 'bold':
						case 'bullet':
						case 'italic':
						case 'kerning':
						case 'underline':
							format[property[0]] = String(property[1]) == 'true';
							break;
						case 'tabStops':
							format[property[0]] = String(property[1]).split('|');
					}
				}
			}
			return format;
		}
	}
}	