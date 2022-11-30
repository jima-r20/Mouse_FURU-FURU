###############################################################
#
# Tool Name         ：マウスふるふる君
# Tool Description  ：入力した時間の間、マウスを動かし続けるツール
# Create/Update Date：2022/11/29
# 
###############################################################

# .NETのCursorクラスを利用するためにSystem.Windows.Formsをロード
Add-Type -AssemblyName System.Windows.Forms

# クラス定義
$Signature = @'
  [DllImport("user32.dll")]
  public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
$SendMouseEvent = Add-Type -MemberDefinition $Signature -Name "Win32MouseEventNew" -Namespace Win32Functions -PassThru

# 実行時間の設定(ユーザ入力)
try {
  $RunTime = Read-Host "Please, enter run time(min)"

  # 開始時刻と終了時刻の設定
  $StartTime = Get-Date
  $EndTime = $StartTime.AddMinutes($RunTime)
  $EndUnixTime = Get-Date -Date $EndTime -UFormat "%s"
}
# 入力内容に不正があった場合、処理を強制終了
catch {
  Write-Host "-----------------------------------------------"
  Write-Host "The entered time is INVALID. Finish processing." 
  Write-Host "" 
  Write-Host "Detail Error Message:" 
  Write-Host $_
  Write-Host "-----------------------------------------------"
  exit
}

# コンソール出力
Write-Host "Run this tool in $($RunTime) min."
Write-Host "Start Time  : $($StartTime)"
Write-Host "End Time    : $($EndTime)"

# マウス移動を意味するイベント値
$MOUSEEVENTF_MOVE = 0x00000001

# マウスの振れ幅(移動距離)
# ・マウス移動イベント生成用
$MovementDistance = 50
# ・マウスの座標を左右にずらす用
$MovementDistance_X = 50

# 奇数回目で右、偶数回目で左に動かすためのフラグ
$MovementFlag = $true

# スリープ時間
$SleepSec = 5

# 処理実行
while ($true) {
  # 現在時刻の取得(Unix秒)
  $NowUnixTime = Get-Date -UFormat "%s"

  # 現在時刻が終了時刻とおなじ、または超えた場合には処理を抜ける
  if (($EndUnixTime - $NowUnixTime) -lt 0) {
    break
  }

  # 現在のマウス座標取得
  $x = [System.Windows.Forms.Cursor]::Position.X
  $y = [System.Windows.Forms.Cursor]::Position.Y

  # マウス座標の移動(スクリーンセーバ、スリープ対策)
  $SendMouseEvent::mouse_event($MOUSEEVENTF_MOVE, - $MovementDistance, 0, 0, 0)
  $SendMouseEvent::mouse_event($MOUSEEVENTF_MOVE, $MovementDistance, 0, 0, 0)

  # 座標を監視するアプリ対策(座標を左か右にずらす)
  if ($MovementFlag) {
    $x += $MovementDistance_X
    $MovementFlag = $false
  }
  else {
    $x -= $MovementDistance_X
    $MovementFlag = $true
  }
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)

  # プログレスバーの表示(進捗確認用)
  $per = [Math]::Round(100 - (($EndUnixTime - $NowUnixTime) / ([int]$RunTime * 60) * 100), 1, [System.MidpointRounding]::AwayFromZero)
  Write-Progress -Activity "Mouse FURU-FURU" -Status "Running..." -PercentComplete $per -CurrentOperation "Now $per % Done"

  # スリープ
  Start-Sleep -Seconds $SleepSec
}

Write-Host "--------------"
Write-Host "  Finished!!"
Write-Host "--------------"
