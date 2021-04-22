//--------------------------Input parameters--------------------------------

		
		file_extension = "tif";		//file extension to process
		mode = "single"; //"single" or "multi"

		combine_mode = 2; // 1 - merge to the right; 2 - merge to the left

		color = newArray(4);
		color[0] = "Blue";
		color[1] = "Green";
		color[2] = "Magenta";
		color[3] = "Magenta";
//--------------------------------------------------------------------------
//---------------------------LUT handling-----------------------------------

LUT_handling_mode = "manual";

// "manual" - select manually
// "auto" - select auto by first frame
// "no" - no LUT selection

//---------------------------Single mode------------------------------------
if(mode == "single"){

	if (LUT_handling_mode == "manual") waitForUser("Select and set LUTs");
	name=getTitle;

Stack.getDimensions(width, height, channels, slices, frames);

   			rename("Rawdata");

   			if (channels > 1){
				run("Split Channels");
	
				for (i = 0; i<channels; i++){
					name_of_channel = "C" + i + 1 + "-Rawdata";
					selectWindow (name_of_channel);
					run(color[i]);
					if(LUT_handling_mode == "auto") run("Enhance Contrast", "saturated=0.35");
				}	
	
				if (channels == 2)
					run("Merge Channels...", "c1=[C2-Rawdata] c2=[C1-Rawdata] create keep");
	
				if (channels == 3)
					run("Merge Channels...", "c1=[C3-Rawdata] c2=[C2-Rawdata] c3=[C1-Rawdata] create keep");
	
				if (channels == 4)
					run("Merge Channels...", "c1=[C4-Rawdata] c2=[C3-Rawdata] c3=[C2-Rawdata] c4=[C1-Rawdata] create keep");
	
				rename ("Composite");
				run("RGB Color",  "frames keep");
				rename ("Composite (RGB)");
	
				selectWindow ("C1-Rawdata");
			
				run("RGB Color",  "frames keep");
				rename ("Combination");
				for (i = 1; i<channels; i++){
					name_of_channel = "C" + i + 1 + "-Rawdata";
					selectWindow (name_of_channel);
					run("RGB Color");
			
					if (i == 1) 
						run("Combine...", "stack1=Combination stack2=C2-Rawdata");
	
					if (i == 2) 
						run("Combine...", "stack1=Combination stack2=C3-Rawdata");
	
					if (i == 3) 
						run("Combine...", "stack1=Combination stack2=C4-Rawdata");
	
			
					rename ("Combination");
				}
	
				if (combine_mode == 1) run("Combine...", "stack1=[Combination] stack2=[Composite (RGB)]");
				if (combine_mode == 2) run("Combine...", "stack1=[Composite (RGB)] stack2=[Combination]");}
	
				rename(name);
}

//--------------------------------------------------------------------------

//--------------------------Multi processing--------------------------------
if (mode=="multi"){
ScreenClean();
//--------------------------Select directory--------------------------------
dir = getDirectory("Choose directory");
list = getFileList(dir);
setBatchMode(true);

file_counter = 0;
for (number_of_file = 0; number_of_file<list.length; number_of_file++){
	if (endsWith(list[number_of_file],file_extension) == 1){
		file_counter ++;
	}
}
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------


if (file_counter == 0){
	waitForUser("Error", "No files detected. Please, check extension");
} 

else {

	flag_lut = false;

	for (k=0; k<list.length; k++) {

		if (endsWith(list[k],file_extension) == 1){

				if (flag_lut == false && LUT_handling_mode == "manual"){
					setBatchMode(false);
					file = File.openDialog("Choose a File");
					run("Bio-Formats Importer", "open=file autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
					Stack.getDimensions(width, height, channels, slices, frames);
					min_array=newArray(frames);
					max_array=newArray(frames);
					waitForUser("Select and set LUTs");
					for (i = 0; i<channels; i++){
					Stack.setPosition(i, 1, 1);
					getMinAndMax(min_array[i], max_array[i]);
					flag_lut = true;
					}
					close();
					setBatchMode(true);
				}
			
				
				file = dir + list[k];
   				run("Bio-Formats Importer", "open=file autoscale color_mode=Default open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

				
   				
				list1 = getList("image.titles");
				
				ser_num = lengthOf(list1);
				
				for (i = 0; i < ser_num; i++) {	
						
				selectWindow(list1[i]);	
				print(list1[i]);
					
				name=getTitle;
				
   				Stack.getDimensions(width, height, channels, slices, frames);

   			rename("Rawdata");

   			if (channels > 1){
				run("Split Channels");
	
				for (i = 0; i<channels; i++){
					name_of_channel = "C" + i + 1 + "-Rawdata";
					selectWindow (name_of_channel);
					if (LUT_handling_mode == "auto") run("Enhance Contrast", "saturated=0.35");
					if (LUT_handling_mode == "manual") setMinAndMax(min_array[i], max_array[i]);
					run(color[i]);
				}	
	
				if (channels == 2)
					run("Merge Channels...", "c1=[C2-Rawdata] c2=[C1-Rawdata] create keep");
	
				if (channels == 3)
					run("Merge Channels...", "c1=[C3-Rawdata] c2=[C2-Rawdata] c3=[C1-Rawdata] create keep");
	
				if (channels == 4)
					run("Merge Channels...", "c1=[C4-Rawdata] c2=[C3-Rawdata] c3=[C2-Rawdata] c4=[C1-Rawdata] create keep");
	
				rename ("Composite");
				run("RGB Color",  "frames keep");
				rename ("Composite (RGB)");
	
				selectWindow ("C1-Rawdata");
				run("RGB Color",  "frames keep");
				rename ("Combination");
				for (i = 1; i<channels; i++){
					name_of_channel = "C" + i + 1 + "-Rawdata";
					selectWindow (name_of_channel);
					run("RGB Color");
			
					if (i == 1) 
						run("Combine...", "stack1=Combination stack2=C2-Rawdata");
	
					if (i == 2) 
						run("Combine...", "stack1=Combination stack2=C3-Rawdata");
	
					if (i == 3) 
						run("Combine...", "stack1=Combination stack2=C4-Rawdata");
	
			
					rename ("Combination");
				}
	
				if (combine_mode == 1)run("Combine...", "stack1=[Combination] stack2=[Composite (RGB)]");
				if (combine_mode == 2) run("Combine...", "stack1=[Composite (RGB)] stack2=[Combination]");
	
				rename(name);
	
				
		
			}
			else {
				rename(name);

				
			}

				filename = dir + name + ".tif";
	
				run("Save", "save=filename");

				name1 = name + ".tif";
				selectWindow(name1);
				close();

				selectWindow("Composite");
				close();
				
				}
   				
			
	
			

		}
	}

}
}
waitForUser("8");

function Deconvolute(name){

	

   			Stack.getDimensions(width, height, channels, slices, frames);

   			rename("Rawdata");

   			if (channels > 1){
				run("Split Channels");
	
				for (i = 0; i<channels; i++){
					name_of_channel = "C" + i + 1 + "-Rawdata";
					selectWindow (name_of_channel);
					run("Enhance Contrast", "saturated=0.35");
					run(color[i]);
				}	
	
				if (channels == 2)
					run("Merge Channels...", "c1=[C2-Rawdata] c2=[C1-Rawdata] create keep");
	
				if (channels == 3)
					run("Merge Channels...", "c1=[C3-Rawdata] c2=[C2-Rawdata] c3=[C1-Rawdata] create keep");
	
				if (channels == 4)
					run("Merge Channels...", "c1=[C4-Rawdata] c2=[C3-Rawdata] c3=[C2-Rawdata] c4=[C1-Rawdata] create keep");
	
				rename ("Composite");
				run("RGB Color",  "frames keep");
				rename ("Composite (RGB)");
	
				selectWindow ("C1-Rawdata");
				run("RGB Color",  "frames keep");
				rename ("Combination");
				for (i = 1; i<channels; i++){
					name_of_channel = "C" + i + 1 + "-Rawdata";
					selectWindow (name_of_channel);
					run("RGB Color");
			
					if (i == 1) 
						run("Combine...", "stack1=Combination stack2=C2-Rawdata");
	
					if (i == 2) 
						run("Combine...", "stack1=Combination stack2=C3-Rawdata");
	
					if (i == 3) 
						run("Combine...", "stack1=Combination stack2=C4-Rawdata");
	
			
					rename ("Combination");
				}
	
				if (combine_mode == 1)run("Combine...", "stack1=[Combination] stack2=[Composite (RGB)]");
				if (combine_mode == 2) run("Combine...", "stack1=[Composite (RGB)] stack2=[Combination]");
	
				rename(name);
	
				
		
			}
			else {
				rename(name);

				
			}
}

//---------------Clean screen from all opened windows------------------------------------------------------
//---------------------------------------------------------------------------------------------------------
function ScreenClean()
      {	
	while (nImages>0) close();

          WinOp=getList("window.titles");
	for(i=0; i<WinOp.length; i++)
	  {selectWindow(WinOp[i]);run ("Close");}

	  fenetres=newArray("B&C","Channels","Threshold");
	for(i=0;i!=fenetres.length;i++)
	   if (isOpen(fenetres[i]))
	    {selectWindow(fenetres[i]);run("Close");}
       }
//---------------------------------------------------------------------------------------------------------