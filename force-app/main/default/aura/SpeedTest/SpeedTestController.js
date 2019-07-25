({
    generatechartdata: function(component, event, helper) {
      var screenWidth = window.innerWidth;

		var margin = {left: 20, top: 20, right: 20, bottom: 20},
			width = Math.min(screenWidth, 400) - margin.left - margin.right,
			height = Math.min(screenWidth, 400) - margin.top - margin.bottom;
					
		var svg = d3.select("#chart").append("svg")
					.attr("width", (width + margin.left + margin.right))
					.attr("height", (height + margin.top + margin.bottom))
				   .append("g").attr("class", "wrapper")
					.attr("transform", "translate(" + (width / 2 + margin.left) + "," + (height / 2 + margin.top) + ")");

		////////////////////////////////////////////////////////////// 
		///////////////////// Data &  Scales ///////////////////////// 
		////////////////////////////////////////////////////////////// 

		//Some random data
		var donutData = [
			{name: "Sales Incomplete", 	value: 1, count: 56},
      {name: "Setup on Hold", 	value: 1, count: 5},
      {name: "QC Assigned",	value: 1, count: 0},
      {name: "Setup Reviewed", 	value: 1, count: 24},
      {name: "1st input scheduled", 	value: 1, count: 52},
			{name: "2nd Check-in Complete", 		value: 1, count: 46}			
		];

		//Create a color scale
		var colorScale = d3.scale.linear()
		   .domain([1,3.5,6])
		   .range(["#2c7bb6", "#ffffbf", "#d7191c"])
		   .interpolate(d3.interpolateHcl);

		//Create an arc function   
		var arc = d3.svg.arc()
			.innerRadius(width*0.75/2) 
			.outerRadius(width*0.75/2 + 10);

		//Turn the pie chart 90 degrees counter clockwise, so it starts at the left	
		var pie = d3.layout.pie()
			.value(function(d) { return d.value; })
			.padAngle(.01)
			.sort(null);
		 
		////////////////////////////////////////////////////////////// 
		//////////////////// Create Donut Chart ////////////////////// 
		////////////////////////////////////////////////////////////// 

		//Create the donut slices and also the invisible arcs for the text 
		svg.selectAll(".donutArcs")
			.data(pie(donutData))
		  .enter().append("path")
			.attr("class", "donutArcs")
			.attr("d", arc)
			.style("fill", function(d,i) {
				if(i === 7) return "#CCCCCC"; //Other
				else return colorScale(i); 
			})
		.each(function(d,i) {
			//Search pattern for everything between the start and the first capital L
			var firstArcSection = /(^.+?)L/; 	

			//Grab everything up to the first Line statement
			var newArc = firstArcSection.exec( d3.select(this).attr("d") )[1];
      var newArc1 = firstArcSection.exec( d3.select(this).attr("d") )[1];
			//Replace all the comma's so that IE can handle it
			newArc = newArc.replace(/,/g , " ");
      newArc1 = newArc1.replace(/,/g , " ");
      
      
			
			//If the end angle lies beyond a quarter of a circle (90 degrees or pi/2) 
			//flip the end and start position
      var isSecondChk = d.data.name.indexOf('2nd Check') > -1;
			if ((!isSecondChk) && d.endAngle > 90 * Math.PI/180) {
				var startLoc 	= /M(.*?)A/,		//Everything between the first capital M and first capital A
					middleLoc 	= /A(.*?)0 0 1/,	//Everything between the first capital A and 0 0 1
					endLoc 		= /0 0 1 (.*?)$/;	//Everything between the first 0 0 1 and the end of the string (denoted by $)
				//Flip the direction of the arc by switching the start en end point (and sweep flag)
				//of those elements that are below the horizontal line
				var newStart = endLoc.exec( newArc )[1];
				var newEnd = startLoc.exec( newArc )[1];
				var middleSec = middleLoc.exec( newArc )[1];
				
				//Build up the new arc notation, set the sweep-flag to 0
				newArc = "M" + newStart + "A" + middleSec + "0 0 0 " + newEnd;
        newArc1 = "M" + newStart + "A" + middleSec + "10 10 100 " + newEnd;
			}//if
			
			//Create a new invisible arc that the text can flow along
			svg.append("path")
				.attr("class", "hiddenDonutArcs")
				.attr("id", "donutArc"+i)
				.attr("d", newArc)
				.style("fill", "none");
        
       
       
 
        
        
        
		});
    
    var dataCircle = [{"cx": -90, "cy": -125, "fill": "#ff0000"}, 
    									{"cx": 90, "cy": -125, "fill": "#00ff00"},
                      {"cx": 150, "cy": 0, "fill": "red"},
                      {"cx": -150, "cy": -0, "fill": "red"},
                      {"cx": -90, "cy": 125, "fill": "red"},
                      {"cx": 90, "cy": 125, "fill": "red"}]
    
    
    
    svg.selectAll("g")
    .data(dataCircle)
  .enter().append("svg:circle")
	.attr("cx", function(d) { return d.cx; })
    .attr("cy", function(d) { return d.cy; })
    .attr("r", 20)
    .attr("class", "white-circle")
    .style("fill", function(d) { return d.fill; });
    
    svg.append("svg:circle")
	.attr("cx", 0)
    .attr("cy", 0)
    .attr("r", 60)
    .attr("class", "white-circle")
    .style("fill", "blue");
			
		//Append the label names on the outside
		svg.selectAll(".donutText")
			.data(pie(donutData))
		   .enter().append("text")
			.attr("class", "donutText")
			//Move the labels below the arcs for those slices with an end angle greater than 90 degrees
			.attr("dy", function(d,i) { 
      	if(d.data.name.indexOf('2nd Check') > -1) {
        	return -34;
        }
        return (d.endAngle > 90 * Math.PI/180 ? 41 : -34);
      })
		  .append("textPath")
			.attr("startOffset","50%")
			.style("text-anchor","middle")
			.attr("xlink:href",function(d,i){return "#donutArc"+i;})
			.text(function(d){
      	return d.data.name;
      });
      
    } 
})