# マウスふるふる君

## ●確認済動作環境
```powershell
PS > $PSVersionTable

Name                           Value
----                           -----
PSVersion                      5.1.19041.1682
PSEdition                      Desktop
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
BuildVersion                   10.0.19041.1682
CLRVersion                     4.0.30319.42000
WSManStackVersion              3.0
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
```


## ●ツール利用にあたっての事前確認・準備
**事前1 Windows PowerShellがあること**<br>
[win]ボタン押下後の一覧に出てくるので、あるか調べる

**事前2 PowerShellでロード済みのアセンブリ確認**<br>

```powershell
PS > [Appdomain]::CurrentDomain.GetAssemblies() | %{$_.GetName().Name}
```

「System.Windows.Forms」が無い場合は、事前3を実施

**事前3 System.Windows.Formsのロード**　※Cursorクラスを利用するため<br>

```powershell
PS > [void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
```

明示的にロードしなくても、ツール内でロードするため不要かもしれないが念のため

**事前4 ツールファイルの準備**<br>
「MoveMouse.ps1」と同様のファイルを準備する。<br>
ファイル名は何でもいいが、拡張子は「.ps1」(ﾋﾟｰｴｽﾜﾝ)にする

**事前5 ツールファイルの配備**<br>
任意の個所に配備(わかりやすいところ)<br>
著者は「デスクトップ」に配備して実行
<br>

## ●ツールの実行方法
**実行1．Windows PowerShellを起動**<br>

**実行2. ディレクトリ移動とツールの実行**<br>
ツールを配備したディレクトリ(フォルダ)に移動し実行する<br>
下記はツールを「デスクトップ」に配備した場合の例(●●●●はユーザ名)

```powershell
PS C:\WINDOWS\system32 > cd C:\Users\●●●●\Desktop
PS C:\Users\●●●●\Desktop > .\MoveMouse.ps1
```

**実行3. 実行期間の入力**<br>
上記「実行2」を実施後、ユーザ入力待ち状態となるので、ツールを実行しておきたい時間を入力<br>
ただし単位は分(min)　※半角数字で入力すること

```powershell
PS C:\Users\●●●●\Desktop > .\MoveMouse.ps1
Please, enter run time(min):
```

**実行4. あとは待つだけ**
「実行3」で実行期間入力後は、実際にツールが実行される<br>
コンソール上には参考程度に、<br>
　Start Time(開始時刻)<br>
　End Time(終了時刻)<br>
　プログレスバー(進捗状況)<br>
が表示される

**実行5. 実行終了**
実行期間を経過後にはコンソール上に以下が表示される<br>
このメッセージが表示されればツールの実行が終了したことを意味する
```
--------------
  Finished!!
--------------
```
<br>
※なお実行途中で強制的に実行終了させたい場合には、<br>
　PowerShellコンソール上で下記を入力すれば強制終了可能<br>
 
```
[Ctrl] + [c]
```

<br>
以上
