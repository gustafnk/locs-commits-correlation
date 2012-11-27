// Run the script on DOM ready:
$(function(){

    var defaults = {
            type: 'dot', 
            width: '960px', 
            height: '400px', 
            parseDirection: 'x', 
            colFilter: ':eq(0)'
        };

	$('table.locs').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(0)'}));
    $('table.commits').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(0)'}));
    
    $('table.full').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(5)'}));
    
    $('table.full').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(3)'}));
    $('table.full').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(4)'}));
    $('table.full').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(2)'}));
    $('table.full').visualize($.extend($.extend({}, defaults), { colFilter: ':eq(6)'}));

    $('table.locs').hide();
    $('table.commits').hide();
    $('table.full').hide();
});