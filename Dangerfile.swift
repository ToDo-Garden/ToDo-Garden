import Danger
import Foundation

let danger = Danger()
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles

// 투두가든 템플릿을 이용해서 Scene 생성시 최대 9개의 파일이 생성됩니다.
// 하나의 PR에 수정된 파일이 최대 9개를 넘지 않도록 합니다.
if editedFiles.count > 10 {
	warn("PR의 단위가 너무 큽니다. \n 다음부터는 PR 단위를 작게 만들 수 있도록 노력해주세요 💪")
}

let swiftLintViolations = SwiftLint.lint(inline: true, configFile: ".swiftlint.yml")

if swiftLintViolations.isEmpty {
	markdown("✅ 모든 파일이 코드 컨벤션을 준수했어요")
	markdown("| ✅ | 🙇🏻‍♂️ 고생 많으셨습니다. |\n|---|----------------------------------------------|")
} else {
	warn("코드 컨벤션 관련 문제를 발견했어요 merge하기 전 확인해주세요 :)")
	markdown("## 🔎👮  Files with violations")
	for violation in swiftLintViolations {
		markdown("- \(violation.file) - \(violation.reason) at line \(violation.line)")
	}
}
