//
//  StopAnimationStyle.swift
//  Rick And Morty
//
//  Created by Anton Babich on 09.06.2020.
//  Copyright © 2020 Anton Babich. All rights reserved.
//

/**
Stop animation style of the `TransitionButton`.
 
 - normal: just revert the button to the original state.
 - expand: expand the button and cover all the screen, useful to do transit animation.
 - shake: revert the button to original state and make a shaoe animation, useful to reflect that something went wrong
 */
public enum StopAnimationStyle {
    case normal
    case expand
    case shake
}
