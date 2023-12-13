import SwiftUI

struct Line {
    var points = [CGPoint]()
    var lineWidth: Double = 10.0
}
//Jefferson
struct ContentView: View {
    @State private var zenSpin = false
    @State private var currentLine = Line()
    @State private var currentLine2 = Line()
    
    @State private var lines = [Line]()
    
    let stepSize = 20
    
    var body: some View {
        var rotationAngle = Angle(degrees: zenSpin ? 360 : 0)
        ZStack{
            Color.white.ignoresSafeArea()
            
            
            VStack {
                ZStack{
                    ExtractedView()
                    Circle().frame(width: 400).foregroundColor(.gray)
                    
                    // CircleView(zenSpin: $zenSpin)
                        .mask(
                            Canvas { context, _ in
                                for line in lines {
                                    var path = Path()
                                    path.addLines(line.points)
                                    context.stroke(path,
                                                   with: .color(.white),
                                                   style: StrokeStyle(lineWidth: line.lineWidth,
                                                                      lineCap: .round,
                                                                      lineJoin: .round)
                                    )
                                }
                            }
                        )
                    
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged({ value in
                                    let newPoint = value.location
                                    // let xOffset = 50 * cos(rotationAngle.radians)
                                    // let yOffset = 50 * sin(rotationAngle.radians)
                                    
                                    currentLine.points.append(newPoint)
                                    
                                    lines.append(currentLine)
                                    // print(xOffset)
                                })
                            
                                .onEnded { _ in
                                    // Clear the current line after dragging ends
                                    currentLine = Line(points: [])
                                    currentLine2 = Line(points: [])
                                }
                            
                        )
                        .rotationEffect(rotationAngle)
                    // ForEach(0..<((355 - 55) / stepSize)) { index in
                    // let circleWidth = CGFloat(55 + index * stepSize)
                    // hollowCircle(lineWidth: 5, circleWidth: circleWidth)
                    
                    // }
                    
                }
                
                
                HStack {
                    Button("Start") {
                        withAnimation(.linear.speed(0.1).repeatForever(autoreverses: false)){
                            zenSpin = true
                        }
                        print("Start Button pressed!")
                    }
                    .disabled(zenSpin)
                    .padding()
                    .background(Color.green)
                    .font(.largeTitle.bold())
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                    
                    Button("Reset") {
                        lines = []
                        currentLine = Line()
                    }
                    .padding()
                    .background(Color.blue)
                    .font(.largeTitle.bold())
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                    
                    Button("Stop") {
                        withAnimation(){
                            zenSpin = false
                        }
                        print("Stop Button pressed!")
                    }
                    .padding()
                    .background(Color.red)
                    .font(.largeTitle.bold())
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                }
                
                
            }
            .padding()
        }
    }
}
#Preview {
    ContentView()
}

struct ExtractedView: View {
    var body: some View {
        Circle().frame(width: 400).foregroundColor(.blue)
        Circle().frame(width: 300).foregroundColor(.white)
        Circle().frame(width: 150).foregroundColor(.cyan)
        Circle().frame(width: 50).foregroundColor(.black)
    }
}
