import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text(CryptoLocalizedStrings.search_crypto_by_name)
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.leading, 4)
                }
                TextField("", text: $searchText)
                    .foregroundColor(.white) 
                    .padding(8)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
            }

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.3))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
