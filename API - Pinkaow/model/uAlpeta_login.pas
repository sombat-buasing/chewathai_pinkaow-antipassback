unit uAlpeta_login;

interface
type
  TAlpeta_login = class
  private
    FUserId: string;
    FPassword: string;
    FUserType: Integer;
  public
    property UserId: string read FUserId write FUserId;
    property Password: string read FPassword write FPassword;
    property UserType: Integer read FUserType write FUserType;
  end;
implementation
end.
