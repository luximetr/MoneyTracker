//
//  TemplatesScreenTemplateTableViewCellController.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 15.02.2022.
//

import UIKit
import AUIKit

final class TemplatesScreenTemplateTableViewCellController: AUIClosuresTableViewCellController {
    
    let templateId: String
    
    init(templateId: String) {
        self.templateId = templateId
    }
}
