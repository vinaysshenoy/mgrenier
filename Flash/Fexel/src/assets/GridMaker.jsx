/*
 * GridMaker automatically generates a new photoshop document and guides based
 * on vertical and horizontal grid specifications and upper limits on document
 * size.  Does not currently do any error-handling so make sure all your inputs
 * are correct.
 *
 * Author: Andrew Ingram
 * Email: andy@andrewingram.net
 */

app.bringToFront();
$.localize = true;

try {
	mainDialog();
}
catch( e ) {
}

function mainDialog() {

	/*
	 * Create the dialog and initial values.  Initial configuration
	 * produces a document with a 64x64 grid with a 3px gutter within
	 * a maximum size of 1024x768
	 */
	var dlg = new Window('dialog', 'GridMaker', [100,100,365,270]);
	
	dlg.vPanel = dlg.add('panel', [5,5,130,130], 'Vertical Guides');
	dlg.vPanel.configLabel = dlg.vPanel.add('statictext', [5,5,115,27], 'Configuration:');
	dlg.vPanel.config = dlg.vPanel.add('edittext', [5,25,115,46], '3,64');
	dlg.vPanel.maxWidthLabel = dlg.vPanel.add('statictext', [5,47,115,69], 'Maximum Width:');
	dlg.vPanel.maxWidth = dlg.vPanel.add('edittext', [5,67,115,88], '1024');
	dlg.vPanel.checkBox = dlg.vPanel.add('checkbox', [5,95,115,110], 'Generate Guides?');
	dlg.vPanel.checkBox.value=true;
	
	dlg.hPanel = dlg.add('panel', [135,5,260,130], 'Horizontal Guides');	
	dlg.hPanel.configLabel = dlg.hPanel.add('statictext', [5,5,115,27], 'Configuration:');
	dlg.hPanel.config = dlg.hPanel.add('edittext', [5,25,115,46], '3,64');
	dlg.hPanel.maxHeightLabel = dlg.hPanel.add('statictext', [5,47,115,69], 'Maximum Height:');
	dlg.hPanel.maxHeight = dlg.hPanel.add('edittext', [5,67,115,88], '768');
	dlg.hPanel.checkBox = dlg.hPanel.add('checkbox', [5,95,115,110], 'Generate Guides?');
	dlg.hPanel.checkBox.value=true;
	
	dlg.okButton = dlg.add('button', [50,140,150,160], 'OK');
	dlg.cancelButton = dlg.add('button', [160,140,260,160], 'Cancel');
	
	/*
	 * okButton Event, performs calculations, generates document and guides, closes dialog.
	 */
	dlg.okButton.onClick = function okClick()
	{
		/*
		 * Split the config string using comma as seperator
		 */	
		var vArray=dlg.vPanel.config.text.split(",");
		var vSum = 0;
		
		/*
		 * Calculate the sum of values in the config string
		 */
		for (i=0;i<vArray.length;i++)
		{
			vArray[i]=vArray[i]*1;
			
			if (isNaN(vArray[i]))
			{
				alert('Invalid Vertical Config');
				return 0;
			}
			
			vSum=vSum+vArray[i];
		}
		
		/*
		 * Work out the maximum width assuming that the first
		 * config value is repeated at the end.  This is done
		 * by first calculating how many times the config fits
		 * completely inside the maximum width.
		 */
		var vCount = (dlg.vPanel.maxWidth.text - vArray[0])/vSum;
		var width=(parseInt(vCount)*vSum)+vArray[0];

		/*
		 * Split the config string using comma as seperator
		 */			
		var hArray=dlg.hPanel.config.text.split(",");
		var hSum = 0;
		
		/*
		 * Calculate the sum of values in the config string
		 */
		for (i=0;i<hArray.length;i++)
		{
			hArray[i]=hArray[i]*1;
			
			if (isNaN(hArray[i]))
			{
				alert('Invalid Horizontal Config');
				return 0;
			}
			
			hSum=hSum+hArray[i];
		}
		
		/*
		 * Work out the maximum height assuming that the first
		 * config value is repeated at the end.  This is done
		 * by first calculating how many times the config fits
		 * completely inside the maximum height.
		 */
		var hCount = (dlg.hPanel.maxHeight.text - hArray[0])/hSum;
		var height=(parseInt(hCount)*hSum)+hArray[0];

		/*
		 * Create the document based on calculated results, fill with white.
		 */		
		var doc = documents.add(width,height,72,"Gridmaker Document",NewDocumentMode.RGB,DocumentFill.WHITE,1.0);
		
		/*
		 * Place vertical guides
		 */
		if (dlg.vPanel.checkBox.value)
		{
			for (i=0; i<parseInt(vCount);i++)
			{
				var x = i*vSum;
				
				var y = 0;
			
				for(j=0;j<vArray.length;j++)
				{
					makeGuide(x+y+vArray[j],"Vrtc");
					y+=vArray[j];
				}
			}
		}
		
		/*
		 * Place horizontal guides
		 */
		if (dlg.hPanel.checkBox.value)
		{
			for (i=0; i<parseInt(hCount);i++)
			{
				var x = i*hSum;
				
				var y = 0;
			
				for(j=0;j<hArray.length;j++)
				{
					makeGuide(x+y+hArray[j],"Hrzn");
					y+=hArray[j];
				}
			}
		}	
		
		/*
		 * Close the dialog window
		 */		
		dlg.close();
	};
	
	/*
	 * cancelButton event, closes the dialog without doing anything
	 */	 
	dlg.cancelButton.onClick = function cancelClick() {
		dlg.close();
	}
	
	/*
	 * finally, we show the dialog. This is where user interaction kicks in
	 */
	dlg.show();
}

/**
 * makeGuide function originally found at:
 * http://blogs.adobe.com/crawlspace/2006/05/installing_and_1.html
 */
function makeGuide(pixelOffSet, orientation) {
    var id8 = charIDToTypeID( "Mk  " );
    var desc4 = new ActionDescriptor();
    var id9 = charIDToTypeID( "Nw  " );
    var desc5 = new ActionDescriptor();
    var id10 = charIDToTypeID( "Pstn" );
    var id11 = charIDToTypeID( "#Rlt" );
    desc5.putUnitDouble( id10, id11, pixelOffSet ); // integer
    var id12 = charIDToTypeID( "Ornt" );
    var id13 = charIDToTypeID( "Ornt" );
    var id14 = charIDToTypeID( orientation ); // "Vrtc", "Hrzn"
    desc5.putEnumerated( id12, id13, id14 );
    var id15 = charIDToTypeID( "Gd  " );
    desc4.putObject( id9, id15, desc5 );
  	executeAction( id8, desc4, DialogModes.NO );
}