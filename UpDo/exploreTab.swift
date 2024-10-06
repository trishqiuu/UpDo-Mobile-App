import SwiftUI

struct exploreTab: View {
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var savedProducts: Set<UUID> = []
    @State private var showingFavorites = false
    @State private var products: [HairProduct] = [
        HairProduct(name: "Moisture Shampoo", brand: "HairCare", imageURL: "shampoo_image", description: "A hydrating shampoo for dry hair."),
        HairProduct(name: "Curl Defining Cream", brand: "CurlMaster", imageURL: "cream_image", description: "Enhance and define your natural curls."),
        HairProduct(name: "Leave-In Conditioner", brand: "HydraLock", imageURL: "conditioner_image", description: "All-day moisture for your hair."),
        HairProduct(name: "Hair Oil", brand: "SilkShine", imageURL: "oil_image", description: "Adds shine and reduces frizz."),
        // Add more sample products here
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.953, green: 0.878, blue: 0.749).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    if isSearching {
                        SearchBar(text: $searchText, isSearching: $isSearching)
                            .padding()
                    }
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredProducts) { product in
                            ProductCard(product: product, isSaved: savedProducts.contains(product.id)) {
                                toggleSaved(for: product)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Explore")
            .navigationBarItems(
                leading: Button(action: {
                    showingFavorites.toggle()
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                },
                trailing: Button(action: {
                    isSearching = true
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(red: 0.347, green: 0.239, blue: 0.173))
                }
            )
        }
    }
    
    var filteredProducts: [HairProduct] {
        if searchText.isEmpty {
            return showingFavorites ? products.filter { savedProducts.contains($0.id) } : products
        } else {
            return products.filter { product in
                (product.name.localizedCaseInsensitiveContains(searchText) ||
                 product.brand.localizedCaseInsensitiveContains(searchText)) &&
                (!showingFavorites || savedProducts.contains(product.id))
            }
        }
    }
    
    func toggleSaved(for product: HairProduct) {
        if savedProducts.contains(product.id) {
            savedProducts.remove(product.id)
        } else {
            savedProducts.insert(product.id)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            TextField("Search products", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            Button(action: {
                text = ""
                isSearching = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ProductCard: View {
    let product: HairProduct
    let isSaved: Bool
    let saveAction: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            NavigationLink(destination: ProductDetailView(product: product, isSaved: isSaved, saveAction: saveAction)) {
                VStack {
                    Image(product.imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipped()
                        .cornerRadius(10)
                    
                    Text(product.name)
                        .font(.headline)
                        .lineLimit(2)
                        .frame(height: 50)
                    
                    Text(product.brand)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(height: 280)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: saveAction) {
                Image(systemName: isSaved ? "heart.fill" : "heart")
                    .foregroundColor(isSaved ? .red : .gray)
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            .padding(8)
        }
    }
}

struct ProductDetailView: View {
    let product: HairProduct
    @State var isSaved: Bool
    let saveAction: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(product.imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                
                Text(product.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(product.brand)
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    isSaved.toggle()
                    saveAction()
                }) {
                    HStack {
                        Image(systemName: isSaved ? "heart.fill" : "heart")
                        Text(isSaved ? "Remove from Favorites" : "Add to Favorites")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.347, green: 0.239, blue: 0.173))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Text("Product Description")
                    .font(.headline)
                    .padding(.top)
                
                Text(product.description)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle(product.name)
        .background(Color(red: 0.953, green: 0.878, blue: 0.749))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HairProduct: Identifiable {
    let id = UUID()
    let name: String
    let brand: String
    let imageURL: String
    let description: String
}

#Preview {
    exploreTab()
}
