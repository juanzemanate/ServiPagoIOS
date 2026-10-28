import SwiftUI


// Equivalente al enum TipoServicio de Kotlin.
enum TipoServicio: String, CaseIterable, Identifiable {
    case AGUA
    case LUZ
    case GAS
    case INTERNET
    case OTRO


    var id: String {
        rawValue
    }


    var etiqueta: String {
        switch self {
        case .AGUA:
            return "Agua"
        case .LUZ:
            return "Luz"
        case .GAS:
            return "Gas"
        case .INTERNET:
            return "Internet"
        case .OTRO:
            return "Otro"
        }
    }
}


// Diálogo para añadir un servicio nuevo.
struct DialogoNuevoServicio: View {


    var onCancelar: () -> Void


    var onGuardar: (
        _ nombre: String,
        _ tipo: TipoServicio,
        _ monto: Int64,
        _ dias: Int
    ) -> Void


    @State private var nombre = ""
    @State private var tipo: TipoServicio = .AGUA
    @State private var monto = ""
    @State private var dias = ""
    @State private var intentoGuardar = false


    private let ColorAcento = Color(
        red: 41.0 / 255.0,
        green: 217.0 / 255.0,
        blue: 232.0 / 255.0
    )


    private let ColorFondoDialogo = Color(
        red: 22.0 / 255.0,
        green: 22.0 / 255.0,
        blue: 22.0 / 255.0
    )


    private let ColorTarjeta = Color(
        red: 58.0 / 255.0,
        green: 58.0 / 255.0,
        blue: 58.0 / 255.0
    )


    private var montoValor: Int64? {
        Int64(monto)
    }


    private var diasValor: Int? {
        Int(dias)
    }


    private var nombreValido: Bool {
        !nombre.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }


    private var montoValido: Bool {
        guard let valor = montoValor else {
            return false
        }


        return valor > 0
    }


    private var diasValido: Bool {
        guard let valor = diasValor else {
            return false
        }


        return (0...365).contains(valor)
    }


    var body: some View {
        VStack(spacing: 0) {


            Text("Nuevo servicio")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(.bottom, 20)


            ScrollView {
                VStack(alignment: .leading, spacing: 14) {


                    campoTexto(
                        titulo: "Nombre del servicio",
                        ejemplo: "Ej: Acueducto",
                        texto: $nombre,
                        error: intentoGuardar && !nombreValido,
                        mensajeError: "Escribe un nombre",
                        maximo: 30
                    )


                    Text("Tipo")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)


                    ScrollView(
                        .horizontal,
                        showsIndicators: false
                    ) {
                        HStack(spacing: 8) {
                            ForEach(TipoServicio.allCases) { opcion in
                                Button {
                                    tipo = opcion
                                } label: {
                                    Text(opcion.etiqueta)
                                        .font(
                                            .system(
                                                size: 13,
                                                weight: .bold
                                            )
                                        )
                                        .foregroundColor(
                                            tipo == opcion
                                            ? .black
                                            : .white
                                        )
                                        .padding(
                                            .horizontal,
                                            14
                                        )
                                        .padding(
                                            .vertical,
                                            8
                                        )
                                        .background(
                                            tipo == opcion
                                            ? ColorAcento
                                            : ColorTarjeta
                                        )
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }


                    campoTexto(
                        titulo: "Monto (COP)",
                        ejemplo: "Ej: 130000",
                        texto: $monto,
                        error: intentoGuardar && !montoValido,
                        mensajeError: "Escribe un monto mayor a 0",
                        soloNumeros: true,
                        maximo: 9
                    )


                    campoTexto(
                        titulo: "Vence en (días)",
                        ejemplo: "Ej: 5",
                        texto: $dias,
                        error: intentoGuardar && !diasValido,
                        mensajeError: "Escribe un número entre 0 y 365",
                        soloNumeros: true,
                        maximo: 3
                    )
                }
                .padding(.bottom, 8)
            }


            HStack {
                Spacer()


                Button("Cancelar") {
                    onCancelar()
                }
                .foregroundColor(.gray)


                Button("Guardar") {
                    intentoGuardar = true


                    guard nombreValido,
                          montoValido,
                          diasValido,
                          let montoFinal = montoValor,
                          let diasFinal = diasValor else {
                        return
                    }


                    onGuardar(
                        nombre.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ),
                        tipo,
                        montoFinal,
                        diasFinal
                    )
                }
                .fontWeight(.bold)
                .foregroundColor(ColorAcento)
                .padding(.leading, 12)
            }
            .padding(.top, 16)
        }
        .padding(22)
        .background(ColorFondoDialogo)
        .preferredColorScheme(.dark)
    }


    private func campoTexto(
        titulo: String,
        ejemplo: String,
        texto: Binding<String>,
        error: Bool,
        mensajeError: String,
        soloNumeros: Bool = false,
        maximo: Int
    ) -> some View {


        VStack(alignment: .leading, spacing: 5) {


            TextField(
                "",
                text: Binding(
                    get: {
                        texto.wrappedValue
                    },
                    set: { nuevoValor in
                        if soloNumeros {
                            texto.wrappedValue = String(
                                nuevoValor.filter {
                                    $0.isNumber
                                }.prefix(maximo)
                            )
                        } else {
                            texto.wrappedValue = String(
                                nuevoValor.prefix(maximo)
                            )
                        }
                    }
                ),
                prompt: Text(ejemplo)
                    .foregroundColor(.gray)
            )
            .keyboardType(
                soloNumeros ? .numberPad : .default
            )
            .foregroundColor(.white)
            .padding(12)
            .background(ColorFondoDialogo)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        error ? Color.red : Color.gray,
                        lineWidth: 1
                    )
            }
            .overlay(alignment: .topLeading) {
                Text(titulo)
                    .font(.system(size: 11))
                    .foregroundColor(
                        error ? .red : ColorAcento
                    )
                    .padding(.horizontal, 5)
                    .background(ColorFondoDialogo)
                    .offset(x: 8, y: -7)
            }
            .padding(.top, 5)


            if error {
                Text(mensajeError)
                    .font(.system(size: 11))
                    .foregroundColor(.red)
            }
        }
    }
}


#Preview {
    DialogoNuevoServicio(
        onCancelar: {},
        onGuardar: { nombre, tipo, monto, dias in
            print(nombre, tipo, monto, dias)
        }
    )
}
