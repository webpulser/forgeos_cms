function toggleEditor(id,textLink)
{
  if (!tinyMCE.get(id))
    {
      tinyMCE.execCommand('mceAddControl', false, id);
      textLink.innerHTML = 'hide editor';
    } else {
      tinyMCE.execCommand('mceRemoveControl', false, id);
      textLink.innerHTML = 'show editor';
  }
}
