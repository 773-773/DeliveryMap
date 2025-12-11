package main

import (
	"strings"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/tools/mailer"
)

func init() {
	app.Hooks.BeforeMailerSend(func(e *mailer.MailEvent) error {

		// 確認メールだけを対象にする
		if strings.Contains(e.Message.Subject, "verify") {

			// ここで本文を書き換えられる
			e.Message.HTML = `
<p>FoodDeliveryEye にご登録いただきありがとうございます。</p>

<p>以下のボタンをクリックして、メールアドレスを認証してください。</p>

<p style="margin-top:12px; padding:12px; background:#ffeeee; border-radius:8px;">
※ 認証後、英語の画面で<br>
「<b>Successfully verified email address.</b>」と表示されれば認証完了です。<br>
そのまま Close を押して閉じてください。
</p>

` + e.Message.HTML // ← PocketBase が生成した元のHTMLを末尾に付け足す
		}

		return nil
	})
}
