class Validator{

  static validField(String text)
  {
    if(text.trim().isEmpty)
      {
        return false;
      }
    else
      {
        return true;
      }
  }
}