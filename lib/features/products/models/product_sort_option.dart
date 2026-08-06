enum ProductSortOption {
  relevance,
  priceAscending,
  priceDescending,
  nameAscending,
  nameDescending,
  bestRated,
  bestDiscount;

  String get label => switch (this) {
        ProductSortOption.relevance => 'Pertinence',
        ProductSortOption.priceAscending => 'Prix croissant',
        ProductSortOption.priceDescending => 'Prix décroissant',
        ProductSortOption.nameAscending => 'Nom A-Z',
        ProductSortOption.nameDescending => 'Nom Z-A',
        ProductSortOption.bestRated => 'Meilleure note',
        ProductSortOption.bestDiscount => 'Meilleure remise',
      };
}
