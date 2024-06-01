import SwiftUI

struct MiscView: View {
  @ObservedObject private var settings = LibKrbn.Settings.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 24.0) {
      GroupBox(label: Text("Extra tool: Multitouch Extension")) {
        VStack(alignment: .leading, spacing: 12.0) {
          HStack {
            Toggle(isOn: $settings.enableMultitouchExtension) {
              Text("Enable Multitouch Extension (Default: off)")
            }
            .switchToggleStyle()

            Spacer()
          }

          VStack(alignment: .leading, spacing: 0.0) {
            Text(
              "Note: This setting is hardware-specific. "
                + "When you import Karabiner-Elements settings to another Mac, "
                + "the enabled state of the Multitouch Extension is not carried over."
            )
          }
          .padding()
          .foregroundColor(Color.infoForeground)
          .background(Color.infoBackground)

          HStack {
            Button(
              action: {
                libkrbn_launch_multitouch_extension()
              },
              label: {
                Label("Open Multitouch Extension Settings", systemImage: "arrow.up.forward.app")
              })

            Spacer()
          }
        }
        .padding(6.0)
      }

      GroupBox(label: Text("Export & Import")) {
        VStack(alignment: .leading, spacing: 12.0) {
          HStack {
            Button(
              action: {
                var buffer = [Int8](repeating: 0, count: 32 * 1024)
                libkrbn_get_user_configuration_directory(&buffer, buffer.count)
                let path = String(cString: buffer)

                let url = URL(fileURLWithPath: path, isDirectory: true)
                NSWorkspace.shared.open(url)
              },
              label: {
                Label(
                  "Open config folder (~/.config/karabiner)", systemImage: "arrow.up.forward.app")
              })

            Spacer()
          }
        }
        .padding(6.0)
      }

      GroupBox(label: Text("System default configuration")) {
        VStack(alignment: .leading, spacing: 12.0) {
          VStack(alignment: .leading, spacing: 0) {
            Text(
              "You can use Karabiner-Elements even before login by setting the system default configuration."
            )
            Text("(These operations require the administrator privilege.)")
          }

          Button(
            action: {
              settings.installSystemDefaultProfile()
            },
            label: {
              Label(
                "Copy the current configuration to the system default configuration",
                systemImage: "square.and.arrow.down")
            })

          if settings.systemDefaultProfileExists {
            Button(
              role: .destructive,
              action: {
                settings.removeSystemDefaultProfile()
              },
              label: {
                Label("Remove the system default configuration", systemImage: "trash")
                  .buttonLabelStyle()
              }
            )
            .deleteButtonStyle()
          } else {
            Text("System default configuration is not set.").foregroundColor(
              Color.primary.opacity(0.5))
          }
        }
        .padding(6.0)
      }

      Spacer()
    }
    .padding()
  }
}

struct MiscView_Previews: PreviewProvider {
  static var previews: some View {
    MiscView()
  }
}
