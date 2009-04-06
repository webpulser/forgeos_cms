var hideTiny = function(id,textLink)
{
    if(tinyMCE.get(id).isHidden())
    {
        tinyMCE.get(id).show();
        textLink.innerHTML = '[hide editor]';
    } else {
        tinyMCE.get(id).hide();
        textLink.innerHTML = '[show editor]';
    }
}