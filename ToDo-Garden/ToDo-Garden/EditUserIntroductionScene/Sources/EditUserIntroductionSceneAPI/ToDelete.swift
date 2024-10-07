// TODO: - ⬇️ 단순 빌드 에러 방지용 임시 프로토콜입니다. ⬇️
/// 빌드 에러를 방지하기 위해 해당 파일을 API 하위로 이동시켜주세요
/// 다음화면이 정해질 경우 대체 될 프로토콜입니다.

public protocol NextScenePayloadable {

}

public protocol NextSceneBuildable {
  func build(with payload: NextScenePayloadable) -> NextSceneViewControllable
}

import ToDoGardenUIAPI

public protocol NextSceneViewControllable: ViewControllable {

}
