//
//  RowDataRepresentation.swift
//  AvitoInternship
//
//  Created by Denis on 13.02.2025.
//

import Foundation

enum rowType: Identifiable {
    var id: Int {
        switch self {
        case .LargeItemRow(let productModel):
            return productModel.id
        case .RegularItemRow(let array):
            return array.map {$0.id}.reduce(0, *)
        }
    }
    
    
    case LargeItemRow(ProductModel)
    case RegularItemRow([ProductModel])
}

struct ProductHolder  {
    var elements: [rowType] = []
    
    
    // пиздец какой-то
    mutating func addElement(newElement: ProductModel) {
        guard !elements.isEmpty else {
            switch newElement.category.sizeType {
            case .large:
                elements.append(rowType.LargeItemRow(newElement))
            case .regular:
                elements.append(rowType.RegularItemRow([newElement]))
            }
            return
        }
        
        
        // имплементируем механизм группировки/расстановки по парам одинакового типоразмера
        switch newElement.category.sizeType {
        case .large:
            elements.append(.LargeItemRow(newElement))
        case .regular:
            for (index, element) in elements.enumerated() {
                switch element {
                case .LargeItemRow(_):
                    continue
                case .RegularItemRow(let productModelArray):
                    if productModelArray.count < 2 {
                        elements[index] = .RegularItemRow(productModelArray+[newElement])
                        return
                    }
                }
            }
            
            // места для потенциальной вставки не нашлось, добавляем новый ряд
            elements.append(.RegularItemRow([newElement]))
        }
    }
    
}

// MARK: - Итератор для ProductHolder
struct ProductHolderIterator: IteratorProtocol {
    private var rowIndex = 0
    private var itemIndex = 0
    private let elements: [rowType]

    init(_ productHolder: ProductHolder) {
        self.elements = productHolder.elements
    }

    mutating func next() -> ProductModel? {
        while rowIndex < elements.count {
            switch elements[rowIndex] {
            case .LargeItemRow(let product):
                rowIndex += 1
                return product
                
            case .RegularItemRow(let products):
                if itemIndex < products.count {
                    let product = products[itemIndex]
                    itemIndex += 1
                    return product
                } else {
                    itemIndex = 0
                    rowIndex += 1
                }
            }
        }
        return nil
    }
}

// MARK: - Поддержка Sequence
extension ProductHolder: Sequence {
    func makeIterator() -> ProductHolderIterator {
        ProductHolderIterator(self)
    }
}
