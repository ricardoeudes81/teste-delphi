unit unDAOFuncionario;

interface

uses
  unConection, Funcionario, DB, FireDAC.Stan.Param, System.Generics.Collections;

type

  TDAOFuncionario = class
  private
    class procedure ExecutarQuery(var Query: TQuery; objFuncionario: TFuncionario);
  public
    class function Insert(objFuncionario: TFuncionario): Integer;
    class function Update(objFuncionario: TFuncionario): Integer;
    class procedure Delete(objFuncionario: TFuncionario);
    class function Load(Id: Integer): TDataSet;
    class function ObterListaFuncionarios(): TObjectList<TFuncionario>;
  end;

implementation

{ TDAOFuncionario }

class procedure TDAOFuncionario.Delete(objFuncionario: TFuncionario);
const
  SQL_DELETE: string = (
    'DELETE FROM FUNCIONARIO WHERE ID = :ID'
  );
begin
  if not Assigned(objFuncionario) then
    Exit;

   var Query := TConexao.GetQuery;
   try
     try
       Query.SQL.Text := SQL_DELETE;
       Query.Close;
       Query.ParamByName('ID').AsInteger := objFuncionario.Id;
       Query.ExecSQL;
       Query.Close;
     except
       TConexao.GetInstance.RollbackRetaining;
     end;
   finally
     Query.DisposeOf;
   end;
end;

class procedure TDAOFuncionario.ExecutarQuery(var Query: TQuery; objFuncionario: TFuncionario);
begin
  Query.Close;
  Query.ParamByName('ID').AsInteger := objFuncionario.Id;
  Query.ParamByName('NOME').AsString := objFuncionario.Nome;
  Query.ParamByName('CPF').AsString := objFuncionario.CPF;
  Query.ParamByName('SALARIO').AsFloat := objFuncionario.Salario;
  Query.ExecSQL;
  Query.Close;
end;

class function TDAOFuncionario.Insert(objFuncionario: TFuncionario): Integer;
const
  SQL_INSERT: string = (
    'INSERT INTO FUNCIONARIO (' + sLineBreak +
    '     ID,' + sLineBreak +
    '     NOME,' + sLineBreak +
    '     CPF,' + sLineBreak +
    '     SALARIO' + sLineBreak +
    ') VALUES (' + sLineBreak +
    '     :ID,' + sLineBreak +
    '     :NOME,' + sLineBreak +
    '     :CPF,' + sLineBreak +
    '     :SALARIO' + sLineBreak +
    ')'
  );
begin
  Result := 0;
  if not Assigned(objFuncionario) then
    Exit;

   var Query := TConexao.GetQuery;
   var NextId := TConexao.GetNextId('FUNCIONARIO', 'ID');

   try
     try
       objFuncionario.Id := NextId;
       Query.SQL.Text := SQL_INSERT;
       ExecutarQuery(Query, objFuncionario);
     except
       TConexao.GetInstance.RollbackRetaining;
     end;
   finally
     Result := objFuncionario.Id;
     Query.DisposeOf;
   end;
end;

class function TDAOFuncionario.Load(Id: Integer): TDataSet;
const
  SQL_SELECT: string = (
    'SELECT * FROM FUNCIONARIO WHERE ID = :ID'
  );
begin
  Result := nil;
  if (Id = 0) then
    Exit;

  var Query := TConexao.GetQuery;
  try
    try
      Query.SQL.Text := SQL_SELECT;
      Query.Close;
      Query.ParamByName('ID').AsInteger := Id;
      Query.Open;
      Result := Query;
    except
      TConexao.GetInstance.RollbackRetaining;
    end;
  finally
    Result := Query;
  end;
end;

class function TDAOFuncionario.ObterListaFuncionarios: TObjectList<TFuncionario>;
const
  SQL_SELECT: string = (
    'SELECT * FROM FUNCIONARIO ORDER BY ID'
  );
begin
  Result := TObjectList<TFuncionario>.Create;
  Result.Clear;

  var Query := TConexao.GetQuery;
  try
    try
      Query.SQL.Text := SQL_SELECT;
      Query.Close;
      Query.Open;
      Query.First;
      while not Query.Eof do
      begin
        var Funcionario := TFuncionario.Create;
        Funcionario.Id := Query.FieldByName('ID').AsInteger;
        Funcionario.Nome := Query.FieldByName('NOME').AsString;
        Funcionario.CPF := Query.FieldByName('CPF').AsString;
        Funcionario.Salario := Query.FieldByName('SALARIO').AsFloat;

        Result.Add(Funcionario);
        Query.Next;
      end;
    except
      TConexao.GetInstance.RollbackRetaining;
    end;
  finally
    Query.DisposeOf;
  end;
end;

class function TDAOFuncionario.Update(objFuncionario: TFuncionario): Integer;
const
  SQL_UPDATE: string = (
    'UPDATE FUNCIONARIO SET' + sLineBreak +
    '   NOME = :NOME,' + sLineBreak +
    '   CPF = :CPF,' + sLineBreak +
    '   SALARIO = :SALARIO' + sLineBreak +
    'WHERE' + sLineBreak +
    '   ID = :ID'
  );
begin
  Result := 0;
  if not Assigned(objFuncionario) then
    Exit;

  var Query := TConexao.GetQuery;
  try
    try
      Query.SQL.Text := SQL_UPDATE;
      ExecutarQuery(Query, objFuncionario);
    except
      TConexao.GetInstance.RollbackRetaining;
    end;
  finally
    Result := objFuncionario.Id;
    Query.DisposeOf;
  end;
end;

end.
