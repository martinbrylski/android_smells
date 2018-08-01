$(document).ready(function() {
    $('#lunr-search').click(function(event) {
        lunrdoc.idx = lunr.Index.load(lunrdoc.indexJson);
        var results = lunrdoc.idx.search($('#lunr-input').val());
        $('#lunr-results').empty();
        for (var i in results) {
            var itemData = lunrdoc.content[results[i].ref];
            var renderedItem = Mustache.render('<div class="smell-result"><a href=".{{url}}">{{title}}</a></div>', itemData);
            $('#lunr-results').append(renderedItem);
        }
    });

    $('#lunr-input').keypress(function(e){
      if(e.keyCode==13)
      $('#lunr-search').click();
    });

    var prmstr = window.location.search.substr(1);
    var prmarr = prmstr.split ("&");
    var params = {};

    for ( var i = 0; i < prmarr.length; i++) {
        var tmparr = prmarr[i].split("=");
        params[tmparr[0]] = tmparr[1];
    }

    $('#lunr-input').val(params.keys);
    $('#lunr-search').click();
});
