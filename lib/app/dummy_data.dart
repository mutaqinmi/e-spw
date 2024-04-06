final List<Map> shop = [
  {
    'shopID': 'PPLG01',
    'profile_picture': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=1381&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'class': 'XI PPLG',
    'name': 'Fiesta Food',
    'rating': 4.8,
  },
  {
    'shopID': 'PPLG02',
    'profile_picture': 'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'class': 'XI PPLG',
    'name': 'Kedai Cici',
    'rating': 4.7,
  },
  {
    'shopID': 'TJKT201',
    'profile_picture': 'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'class': 'XI TJKT 2',
    'name': 'Si Cepot',
    'rating': 4.6,
  },
  {
    'shopID': 'TJKT202',
    'profile_picture': 'https://images.unsplash.com/photo-1533910534207-90f31029a78e?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'class': 'XI TJKT 2',
    'name': 'Kedai Naasa',
    'rating': 4.7,
  },
  {
    'shopID': 'DPIB201',
    'profile_picture': 'https://images.unsplash.com/photo-1483695028939-5bb13f8648b0?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'class': 'XI DPIB 2',
    'name': 'Warung Kopi',
    'rating': 4.8,
  }
];

final List<Map> products = [
  {
    'productID': 'PPLG0101',
    'shop_name': 'Fiesta Food',
    'product_image': 'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'product_name': 'Ayam Goreng',
    'stock': 20,
    'sold_total': 0,
    'price': 8000,
    'rating': 4.7,
    'is_open': true,
  },
  {
    'productID': 'TJKT20201',
    'shop_name': 'Kedai Naasa',
    'product_image': 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?q=80&w=1364&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'product_name': 'Es Teh Manis',
    'stock': 50,
    'sold_total': 0,
    'price': 3000,
    'rating': 4.9,
    'is_open': false,
  },
  {
    'productID': 'DPIB20101',
    'shop_name': 'Warung Kopi',
    'product_image': 'https://images.unsplash.com/photo-1529218991349-10f9728c3b32?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'product_name': 'Creamy Pancake',
    'stock': 20,
    'sold_total': 0,
    'price': 5000,
    'rating': 4.7,
    'is_open': false,
  }
];

final List<Map> carts = [
  {
    'cartID': 'CART001',
    'extra': [
      'Pedas',
      'Gurih'
    ],
    'qty': 0,
    'product': [
      {
        'productID': 'PPLG0101',
        'shop_name': 'Fiesta Food',
        'product_image': 'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'product_name': 'Ayam Goreng',
        'stock': 20,
        'sold_total': 0,
        'price': 8000,
        'rating': 4.7,
        'is_open': true,
      }
    ]
  },
  {
    'cartID': 'CART002',
    'extra': [],
    'qty': 0,
    'product': [
      {
        'productID': 'TJKT20201',
        'shop_name': 'Kedai Naasa',
        'product_image': 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?q=80&w=1364&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'product_name': 'Es Teh Manis',
        'stock': 50,
        'sold_total': 0,
        'price': 3000,
        'rating': 4.9,
        'is_open': false,
      }
    ],
  }
];