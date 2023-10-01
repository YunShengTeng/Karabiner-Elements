import SwiftUI

struct ContentView: View {
  @ObservedObject var inputMonitoringAlertData = InputMonitoringAlertData.shared
  @ObservedObject var eventObserver = EventObserver.shared
  @ObservedObject var stickManager = StickManager.shared

  let circleSize = 100.0
  let stickDivider = 50.0

  var body: some View {
    VStack {
      VStack(alignment: .leading) {
        Text("counter: \(eventObserver.counter)")

        StickInfo(label: "Right Stick X", stick: stickManager.rightStickX)
        StickInfo(label: "Right Stick Y", stick: stickManager.rightStickY)
      }

      ZStack(alignment: .center) {
        Circle()
          .stroke(Color.gray, lineWidth: 2)
          .frame(width: circleSize, height: circleSize)

        Path { path in
          path.move(to: CGPoint(x: circleSize / 2.0, y: circleSize / 2.0))
          path.addLine(
            to: CGPoint(
              x: stickManager.rightStickX.lastAcceleration / stickDivider * circleSize
                + circleSize / 2.0,
              y: stickManager.rightStickY.lastAcceleration / stickDivider * circleSize
                + circleSize / 2.0
            ))
        }
        .stroke(Color.red, lineWidth: 2)
        .frame(width: circleSize, height: circleSize)
      }
    }
    .alert(isPresented: inputMonitoringAlertData.showing) {
      InputMonitoringAlertView()
    }
    .frame(
      minWidth: 1100,
      maxWidth: .infinity,
      minHeight: 650,
      maxHeight: .infinity)
  }
}

struct StickInfo: View {
  let label: String
  @ObservedObject var stick: StickManager.Stick

  var body: some View {
    VStack(alignment: .leading) {
      Text("\(label):")
      Text("    value: \(stick.value)")
      Text("    interval: \(stick.lastInterval)")
      Text("    acceleration: \(stick.lastAcceleration)")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
