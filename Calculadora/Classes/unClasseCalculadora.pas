unit unClasseCalculadora;

interface

type

  TTipoOperacao = (tpoNada, tpoSoma, tpoSubtracao, tpoMultiplicacao, tpoDivisao);


  TOperacao = class(TObject)
    function Calculo(): Double; virtual; abstract;
  end;


  TCalculadora = class(TOperacao)
  private
    FprimeiraVez: Boolean;
  public
    class var operacaoAtiva: TTipoOperacao;
    class var nUltimoDigitado: Double;
    class var nNumeroAnterior: Double;
    class var nNumeroAtual: Double;
    class var zerar: Boolean;

    property primeiraVez: Boolean read FprimeiraVez write FprimeiraVez;
  end;


  TOperacaoSoma = class(TCalculadora)
  public
    function Calculo(): Double; override;
  end;


  TOperacaoSubtracao = class(TCalculadora)
  public
    function Calculo(): Double; override;
  end;


  TOperacaoMultiplicacao = class(TCalculadora)
  public
    function Calculo(): Double; override;
  end;


  TOperacaoDivisao = class(TCalculadora)
  public
    function Calculo(): Double; override;
  end;


implementation

{ TOperacaoSoma }

function TOperacaoSoma.Calculo: Double;
begin
  TCalculadora.operacaoAtiva := tpoSoma;
  if (primeiraVez) then
  begin
    primeiraVez := False;
    nNumeroAnterior := nUltimoDigitado;
    Result := nNumeroAtual;
  end
  else
  begin
    Result := nNumeroAnterior + nNumeroAtual;
    nNumeroAnterior := nUltimoDigitado;
  end;
end;

{ TOperacaoSubtracao }

function TOperacaoSubtracao.Calculo: Double;
begin
  TCalculadora.operacaoAtiva := tpoSubtracao;
  if (primeiraVez) then
  begin
    primeiraVez := False;
    nNumeroAnterior := nUltimoDigitado;
    Result := nNumeroAtual;
  end
  else
  begin
    Result := nNumeroAtual - nUltimoDigitado;
    nNumeroAtual := Result;
  end;
end;

{ TOperacaoMultiplicacao }

function TOperacaoMultiplicacao.Calculo: Double;
begin
  TCalculadora.operacaoAtiva := tpoMultiplicacao;
  if (primeiraVez) then
  begin
    primeiraVez := False;
    nNumeroAnterior := nUltimoDigitado;
    Result := nNumeroAtual;
  end
  else
  begin
    Result := nNumeroAnterior * nNumeroAtual;
    nNumeroAnterior := nUltimoDigitado;
  end;
end;

{ TOperacaoDivisao }

function TOperacaoDivisao.Calculo: Double;
begin
  TCalculadora.operacaoAtiva := tpoDivisao;
  if (primeiraVez) then
  begin
    primeiraVez := False;
    nNumeroAnterior := nUltimoDigitado;
    Result := nNumeroAtual;
  end
  else
  begin
    if nNumeroAtual = 0 then
      Result := 0
    else
      Result := nNumeroAnterior / nNumeroAtual;
    nNumeroAnterior := nUltimoDigitado;
  end;
end;

end.
