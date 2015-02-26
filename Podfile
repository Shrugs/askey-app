source 'https://github.com/CocoaPods/Specs.git'

platform :ios, "8.1"

def import_pods
    pod 'Masonry'
    pod 'pop'
    pod 'MCBouncyButton'
end

target :ASCIIboardContainer do

    link_with 'ASCIIboardContainer'

    import_pods
    pod 'SDiPhoneVersion', '~> 1.1.1'
    pod 'iOS-MagnifyingGlass', '~> 0.0.2'
    pod 'JazzHands', '~> 0.1.1'
end

target :ASCIIboard do

    link_with 'ASCIIboard'

    import_pods
    pod 'LIVBubbleMenu', :git => 'https://github.com/Shrugs/LIVBubbleMenu-iOS.git', :branch => 'bganimation-fix'
    pod 'ACEDrawingView'
end