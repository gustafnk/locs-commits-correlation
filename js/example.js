// Run the script on DOM ready:
$(function(){

    var defaults = {
            type: 'dot', 
            width: '960px', 
            height: '400px', 
            parseDirection: 'x',
            colors: ["#e9e744"]
        };

	$('table.locs').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(1)'}));
    $('table.commits').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(1)'}));
    $('table.factor').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(1)'}));
    
    $('table.full').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(5)'}));
    
    $('table.full').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(3)'}));
    $('table.full').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(4)'}));
    $('table.full').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(2)'}));
    
    $('table.locs').hide();
    $('table.commits').hide();
    $('table.factor').hide();
    $('table.full').hide();
});