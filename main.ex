defmodule InventoryManager do

  defstruct products: [], cart_articles: [], total_cart_amount: []


  def add_product(%InventoryManager{products: products} = inventory, name, price, stock) do
    id = Enum.count(products) + 1
    product = %{id: id, name: name, price: price, stock: stock}
    %{inventory | products: products ++ [product]}
  end

  def list_products(%InventoryManager{products: products} = inventory) do
    Enum.each(products, fn product ->
      IO.puts("#{product.id}. #{product.name}. #{product.price}. #{product.stock}")
    end)
  end

  def increase_stock(%InventoryManager{products: products} = inventory, id, quantity) do
    updated_products = Enum.map(products, fn product ->
      if product.id == id do
        %{product | stock: product.stock + quantity}
      else
        product
      end
    end)
    %{inventory | products: updated_products}
  end

  def list_shopping_cart(%InventoryManager{cart_articles: articles, total_cart_amount: amount}) do
    Enum.each(articles, fn article ->
      IO.puts("#{article.id}. #{article.quantity}.")
    end)
    IO.puts("#{amount}")
  end

  def sell_product(%InventoryManager{products: products, cart_articles: articles, total_cart_amount: amount} = inventory, id, quantity) do
    new_inventory = check_stock(inventory, id, quantity)
    new_inventory_1 = add_item_to_shoppingcart(new_inventory, id, quantity)
    new_inventory_2 = set_amount(new_inventory_1, id, quantity)
  end

  defp check_stock(%InventoryManager{products: products} = inventory, id, quantity) do
    updated_products = Enum.map(products, fn product ->
      if product.id == id do
        if product.stock >= quantity do
          %{product | stock: product.stock - quantity}
        else
          IO.puts("No hay suficiente stock para la cantidad deseada")
        end
      else
        product
      end
    end)
    %{inventory | products: updated_products}
  end

  defp add_item_to_shoppingcart(%InventoryManager{products: products, cart_articles: articles} = inventory, id, desired_quantity) do
    updated_cart_articles = articles ++ [%{id: id, quantity: desired_quantity}]
    %{inventory | cart_articles: updated_cart_articles}
  end

  defp set_amount(%InventoryManager{products: products, total_cart_amount: _amount} = inventory, id, desired_quantity) do
    updated_products = Enum.map(products, fn product ->
      if product.id == id do
        %{inventory | total_cart_amount: [product.price * desired_quantity]}
      else
        product
      end
    end)
    %{inventory | products: updated_products}
  end

  def run do
    inventory = %InventoryManager{}
    inventory = add_product(inventory, "holis", 5, 10)
    loop(inventory)
  end

  defp loop(inventory) do
    IO.puts("""
    Gestor de Inventario:
    1. Agregar producto
    2. Listar productos
    3. Incrementar stock
    4. Vender producto
    5. Listar carrito
    """)
    
    IO.write("Seleccione una opción: ")
    option = IO.gets("") |> String.trim() |> String.to_integer()

    case option do
      1 ->
        IO.write("Ingrese el nombre del producto: ")
        name = IO.gets("") |> String.trim()
        IO.write("Ingrese el precio del producto: ")
        price = IO.gets("") |> String.trim() |> String.to_integer()
        IO.write("Ingrese el stock del producto: ")
        stock = IO.gets("") |> String.trim() |> String.to_integer()
        inventory = add_product(inventory, name, price, stock)
        loop(inventory)

      2 ->
        list_products(inventory)
        loop(inventory)

      3 ->
        IO.write("Ingrese el ID del producto: ")
        id = IO.gets("") |> String.trim() |> String.to_integer()
        IO.write("Ingrese la cantidad de unidades nuevas del producto: ")
        incoming_products = IO.gets("") |> String.trim() |> String.to_integer()
        inventory = increase_stock(inventory, id, incoming_products)
        loop(inventory)

      4 ->
        IO.write("Ingrese el ID del producto: ")
        id = IO.gets("") |> String.trim() |> String.to_integer()
        IO.write("Ingrese la cantidad de articulos deseados: ")
        incoming_products = IO.gets("") |> String.trim() |> String.to_integer()
        inventory = sell_product(inventory, id, incoming_products)
        loop(inventory)

      5 ->
        list_shopping_cart(inventory)
        loop(inventory)

      _ ->
        IO.puts("Opción no válida.")
        loop(inventory)
    end
  end
end

# Ejecutar el gestor de tareas
InventoryManager.run()
