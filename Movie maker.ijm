//-----------------------------Dark frames-----------------------------
channel_1 = 0;
channel_2 = 6;
channel_3 = 0;
channel_4 = 0;

color_1 = "Cyan";
color_2 = "Red";
color_3 = "Blue";
color_4 = "Green";

//---------------------------------------------------------------------




dir = File.directory;
setBatchMode (true);
Stack.getDimensions(width33, height33, channels33, slices33, n);
rename ("Untitled");
selectWindow("Untitled");
run("Duplicate...", "duplicate frames=1-1");

if (channels33 > 1) run("Split Channels"); else rename ("C1-Untitled-1");



if (channels33 >= 1){
selectWindow("C1-Untitled-1");
//run("Brightness/Contrast...");
if (channel_1 < 1) run("Enhance Contrast", "saturated=0.35"); else setMinAndMax(0, 10000);
run(color_1);}

if (channels33 >= 2){
selectWindow("C2-Untitled-1");
//run("Brightness/Contrast...");
if (channel_2 < 1)run("Enhance Contrast", "saturated=0.35"); else setMinAndMax(0, 10000);
run(color_2);}

if (channels33 >= 3){
selectWindow("C3-Untitled-1");
//run("Brightness/Contrast...");
if (channel_3 < 1)run("Enhance Contrast", "saturated=0.35"); else setMinAndMax(0, 10000);
run(color_3);}

if (channels33 >= 4){
selectWindow("C4-Untitled-1");
//run("Brightness/Contrast...");
if (channel_4 < 1)run("Enhance Contrast", "saturated=0.35"); else setMinAndMax(0, 10000);
run(color_4);}

merge_line= "";

for (j = 0; j < channels33; j++){
	merge_line= merge_line + "c" + j+1 + "=C" + j+1 + "-Untitled-1 ";
}
merge_line = merge_line + "create keep";
run("Merge Channels...", merge_line);
run("RGB Color");

selectWindow("C1-Untitled-1");
run("RGB Color");
selectWindow("C2-Untitled-1");
run("RGB Color");
if (channels33 >= 3){
selectWindow("C3-Untitled-1");
run("RGB Color");}
if (channels33 >= 4){
selectWindow("C4-Untitled-1");
run("RGB Color");}

selectWindow("C1-Untitled-1");
rename ("Combined Stacks");

for (j = 1; j<channels33; j++){
					name_of_channel = "C" + j+1 + "-Untitled-1";
					selectWindow (name_of_channel);
					run("RGB Color");
			
					if (j == 1) 
						run("Combine...", "stack1=[Combined Stacks] stack2=C2-Untitled-1");
	
					if (j == 2) 
						run("Combine...", "stack1=[Combined Stacks] stack2=C3-Untitled-1");
	
					if (j == 3) 
						run("Combine...", "stack1=[Combined Stacks] stack2=C4-Untitled-1");
	
			
					rename ("Combined Stacks");
				}
//run("Combine...", "stack1=C1-Untitled-1 stack2=C2-Untitled-1");

run("Combine...", "stack1=[Combined Stacks] stack2=[Untitled-1 (RGB)]");
rename ("Movie");
selectWindow("Untitled-1");
close();

for( i = 2; i <= n; i++) {
selectWindow("Untitled");
run("Duplicate...", "duplicate frames=i-i");
run("Split Channels");


if (channels33 >= 1){
selectWindow("C1-Untitled-1");
//run("Brightness/Contrast...");
if (channel_1 < i) run("Enhance Contrast", "saturated=0.35"); else setMinAndMax(0, 10000);
run(color_1);}

if (channels33 >= 2){
selectWindow("C2-Untitled-1");
//run("Brightness/Contrast...");
if (channel_2 < i)run("Enhance Contrast", "saturated=0.35"); else setMinAndMax(0, 10000);
run(color_2);}

if (channels33 >= 3){
selectWindow("C3-Untitled-1");
//run("Brightness/Contrast...");
if (channel_3 < i)run("Enhance Contrast", "saturated=0.35"); else setMinAndMax(0, 10000);
run(color_3);}

if (channels33 >= 4){
selectWindow("C4-Untitled-1");
//run("Brightness/Contrast...");
if (channel_4 < i)run("Enhance Contrast", "saturated=0.35"); else setMinAndMax(0, 10000);
run(color_4);}

//run("Merge Channels...", "c1=C1-Untitled-1 c2=C2-Untitled-1 create keep");

merge_line= "";

for (j = 0; j < channels33; j++){
	merge_line= merge_line + "c" + j+1 + "=C" + j+1 + "-Untitled-1 ";
}
merge_line = merge_line + "create keep";
run("Merge Channels...", merge_line);
run("RGB Color");


//run("RGB Color");
selectWindow("C1-Untitled-1");
run("RGB Color");
selectWindow("C2-Untitled-1");
run("RGB Color");
if (channels33 >= 3){
selectWindow("C3-Untitled-1");
run("RGB Color");}
if (channels33 >= 4){
selectWindow("C4-Untitled-1");
run("RGB Color");}

selectWindow("C1-Untitled-1");
rename ("Combined Stacks");

for (j = 1; j<channels33; j++){
					name_of_channel = "C" + j+1 + "-Untitled-1";
					selectWindow (name_of_channel);
					run("RGB Color");
			
					if (j == 1) 
						run("Combine...", "stack1=[Combined Stacks] stack2=C2-Untitled-1");
	
					if (j == 2) 
						run("Combine...", "stack1=[Combined Stacks] stack2=C3-Untitled-1");
	
					if (j == 3) 
						run("Combine...", "stack1=[Combined Stacks] stack2=C4-Untitled-1");
	
			
					rename ("Combined Stacks");
				}
				
run("Combine...", "stack1=[Combined Stacks] stack2=[Untitled-1 (RGB)]");
rename ("Movie1");

if (image_exists("Untitled-1")){
selectWindow("Untitled-1");
close();}
run("Concatenate...", "  title=Movie open image1=Movie image2=Movie1");
if (image_exists("Movie1")){
selectWindow("Movie1");
close();}
line = "frames processed " + i;
print (line);
}


run("Scale Bar...", "width=10 height=6 font=20 color=White background=None location=[Lower Right] bold label");

/*
newImage("top_stripe", "RGB color-mode", 1536, 176, 1, 1, n);
newImage("bottom_stripe", "RGB color-mode", 1536, 176, 1, 1, n);

run("Combine...", "stack1=top_stripe stack2=Movie combine");
rename("Movie");
run("Combine...", "stack1=Movie stack2=bottom_stripe combine");*/
filename = dir + File.separator + "Movie.tif";

saveAs("Tiff", filename);

filename = dir + File.separator + "Movie_1.mov";
line= "frame=4.5 container=.avi using=H.264 video=excellent save=" + filename;
run("Movie...", "frame=4.5 container=.avi using=H.264 video=excellent save=filename");
waitForUser("8");
//run("Colors...", "foreground=white background=black selection=blue");

//run("Time Stamper", "starting=0 interval=20 x=5 y=20 font=20 '00 decimal=2 anti-aliased or=min");

function image_exists (name){
	 list = getList("image.titles");
		flag = false;
	 for (j = 0; j < list.length; j++) {
	 	if (list[j] == name) flag = true;
	 }

	 return flag;
}
