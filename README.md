# elpo_book_project

스케줄링 앱 <사부작>을 개발하기 위한 프로젝트

# UI / Navigation Architecture

이 앱은 MainShell 중심의 단일 Scaffold 구조를 사용한다.  
전역 UI(AppBar, BottomNavigationBar, FAB)는 하나의 Shell에서 관리하며,  
각 화면은 Shell 안에서 교체되는 콘텐츠 View로 취급한다.

---

## 1. 구조 개요

```text
MainShell (Scaffold)
 ├─ AppBar
 ├─ BottomNavigationBar
 ├─ FloatingActionButton (탭 단위 액션)
 └─ NavigationShell (IndexedStack)
     ├─ HomeView
     ├─ ProjectView
     ├─ ScheduleView
     └─ SettingView
````

* `MainShell`은 앱 전체의 UI 프레임(App Chrome)을 담당한다.
* Home / Project / Schedule / Setting 화면은 `Scaffold`를 가지지 않는다.
* 각 View는 레이아웃과 콘텐츠만 표현한다.

---

## 2. 이 구조를 선택한 이유

### 2.1 앱 성격에 따른 판단

* 앱 규모가 크지 않음
* 전역 AppBar / BottomNavigationBar가 항상 유지됨
* 탭 간 이동 시 상태 유지가 중요함

이 조건에서는 화면을 교체하는 방식보다,
이미 존재하는 화면을 전환하는 방식이 더 적합하다고 판단했다.

---

### 2.2 StatefulNavigationShell 사용 이유

* `IndexedStack` 기반으로 각 탭의 상태를 유지
* 탭 이동 시 rebuild 최소화
* 스크롤 위치, 내부 상태가 유지됨

탭 전환을 “페이지 이동”이 아니라
섹션 전환으로 인식시키는 것이 UX 측면에서도 더 적합하다.

---

## 3. View에 Scaffold를 두지 않은 이유

HomeView 예시:

```dart
class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HomeTimerCard(),
        TodayPlanCard(),
      ],
    );
  }
}
```

### 의도된 설계이다.

* AppBar / BottomNavigationBar 중복 제거
* UI 정책을 한 곳(MainShell)에서 관리
* 화면 간 UI 일관성 유지

> 각 View는 독립적인 화면이 아니라
> MainShell 내부에 표시되는 콘텐츠 페이지로 취급한다.

---

## 4. FloatingActionButton 정책

* FAB은 화면 단위가 아니라 탭 단위 액션이다.
* 따라서 FAB는 View가 아니라 `MainShell`에 위치한다.

### 예시 정책

* Home → FAB 없음
* Project → “프로젝트 생성” FAB 표시
* Schedule → FAB 없음
* Setting → FAB 없음

```dart
final showProjectFab = currentIndex == 1;
```

---

## 5. 예외 라우트 정책 (Shell 외부 화면)

일부 화면은 Shell 구조에 포함되지 않는다.

### 예시

* 타이머 확장 화면

```text
MainShell (탭 UI)
TimerExpandView (전체 화면)
```

이 경우:

* 별도의 라우트로 분리
* 자체 `Scaffold` 사용
* 전역 AppBar / BottomNavigationBar 없음

이는 일시적 집중 화면(full-focus screen) 이라는 UX 의도 때문이다.

---

## 6. 화면 회전 정책

* 앱은 기본적으로 세로 모드만 지원한다.
* 가로 모드는 UX 품질이 떨어진다고 판단하여 의도적으로 비활성화했다.
* 예외적으로 타이머 확장 화면만 가로 UI를 사용한다.

이는 기술적 한계가 아니라 UX 기준의 선택이다.

---

## 7. 장단점 분석

### 장점

* 구조 단순
* 상태 관리 명확
* UI 정책 일관성 유지
* 유지 비용이 낮음

### 단점

* View 단독 재사용성은 낮음
* 특정 화면만 다른 AppBar/FAB을 쓰려면 Shell 분기 필요

> 현재 앱 규모와 목적을 고려하면
> 단점보다 장점이 훨씬 크다고 판단했다.

---

## 8. 결론

* 이 앱은 MainShell 중심 아키텍처를 채택한다.
* 이는 임시 구현이 아니라 의도된 구조적 선택이다.
* 구조 변경이 필요해질 경우, 앱 규모 확장 시점에 재검토한다.

```

