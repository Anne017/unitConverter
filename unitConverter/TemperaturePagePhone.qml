import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import Ubuntu.Components.ListItems 1.3 as ListItem
import QtQuick.LocalStorage 2.0

import "Storage.js"  as Storage
import "Utility.js" as Utility

/*
  Temperature unit converter page for Phone
*/

Page {
     id: temperaturePagePhone
     visible: false     

     header: PageHeader {
        title: i18n.tr("Temperature conversions")
     }

     /* define how to render the entry in the OptionSelector */
     Component {
         id: temperatureUnitsListModelDelegate
         OptionSelectorDelegate { text: sourceUnit; subText: sourceUnitSymbol; }
     }

     /* ------------- Source Unit Chooser --------------- */
     Component {
         id: sourceTemperatureUnitsChooserComponent

         Dialog {
             id: temperatureUnitsChooserDialog
             title: i18n.tr("Found "+temperatureUnitsListModel.count+ " temperature units")

             OptionSelector {
                 id: temperatureUnitsOptionSelector
                 expanded: true
                 multiSelection: false
                 delegate: temperatureUnitsListModelDelegate
                 model: temperatureUnitsListModel
                 containerHeight: itemHeight * 4
             }

             Row {
                 spacing: units.gu(2)
                 Button {
                     text: i18n.tr("Close")
                     width: units.gu(14)
                     onClicked: {
                         PopupUtils.close(temperatureUnitsChooserDialog)
                     }
                 }

                 Button {
                     text: i18n.tr("Select")
                     width: units.gu(14)
                     onClicked: {
                         sourceUnitChooserButton.text = temperatureUnitsListModel.get(temperatureUnitsOptionSelector.selectedIndex).sourceUnit;
                         //reset previous convertions
                         convertedValue.text= ''
                         convertedValue.enabled= false
                         PopupUtils.close(temperatureUnitsChooserDialog)
                     }
                 }
             }
         }
     }


     /* ------------- Destination Unit Chooser --------------- */
     Component {
         id: destinationTemperatureUnitsChooserComponent

         Dialog {
             id: temperatureUnitsChooserDialog
             title: i18n.tr("Found "+temperatureUnitsListModel.count+ " temperature units")

             OptionSelector {
                 id: temperatureUnitsOptionSelector
                 expanded: true
                 multiSelection: false
                 delegate: temperatureUnitsListModelDelegate
                 model: temperatureUnitsListModel
                 containerHeight: itemHeight * 4
             }

             Row {
                 spacing: units.gu(2)
                 Button {
                     text: i18n.tr("Close")
                     width: units.gu(14)
                     onClicked: {
                         PopupUtils.close(temperatureUnitsChooserDialog)
                     }
                 }

                 Button {
                     text: i18n.tr("Select")
                     width: units.gu(14)
                     onClicked: {
                         destinationUnitChooserButton.text = temperatureUnitsListModel.get(temperatureUnitsOptionSelector.selectedIndex).sourceUnit;
                         //reset previous convertions
                         convertedValue.text= ''
                         convertedValue.enabled= false
                         PopupUtils.close(temperatureUnitsChooserDialog)
                     }
                 }
             }
         }
    }

     Column{
        id: temperaturePageColumn
        spacing: units.gu(2)
        anchors.fill: parent

        /* transparent placeholder: to place the content under the header */
        Rectangle {
            color: "transparent"
            width: parent.width
            height: units.gu(6)
        }

        Row{
            id: sourceUnitRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing:units.gu(1)

            Label{
                id: sourceUnitLabel
                anchors.verticalCenter: valueToConvertField.verticalCenter
                text: i18n.tr("From:")
            }

            TextField{
                id: valueToConvertField
                width: units.gu(25)
                enabled:true
            }
         }

         Row{
             anchors.horizontalCenter: parent.horizontalCenter
             spacing:units.gu(1)

             Rectangle {
                 color: "transparent"
                 width: sourceUnitLabel.width
                 height: units.gu(1)
             }

             Button{
                 id: sourceUnitChooserButton
                 width: units.gu(25)
                 color: UbuntuColors.warmGrey
                 iconName: "find"
                 text: i18n.tr("Choose...")
                 onClicked:  {
                    PopupUtils.open(sourceTemperatureUnitsChooserComponent, sourceUnitChooserButton)
                 }
             }
         }


         /* line separator */
         Rectangle {
               color: "grey"
               width: parent.width
               anchors.horizontalCenter: parent.horizontalCenter
               height: units.gu(0.1)
         }

        /* ------------------ Destination Unit row ------------------ */
        Row{
            id: destinationUnitRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing:units.gu(3)

            Label{
                id: destinationUnitLabel
                anchors.verticalCenter: destinationUnitChooserButton.verticalCenter
                text: i18n.tr("To:")
            }           

            Button{
                id: destinationUnitChooserButton
                x: sourceUnitChooserButton.x
                width: units.gu(25)
                color: UbuntuColors.warmGrey
                iconName: "find"
                text: i18n.tr("Choose...")
                onClicked:  {
                    PopupUtils.open(destinationTemperatureUnitsChooserComponent, destinationUnitChooserButton)
                }
            }
        }

        /* ------------ Result Row ----------- */
        Row{
            id: resultRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing:units.gu(3)

            /* transparent placeholder: required to place the content under the header */
            Rectangle {
                 color: "transparent"
                 width: destinationUnitLabel.width
                 height: units.gu(6)
            }

            TextField{
                id: convertedValue
                width: units.gu(25)
                enabled:false
            }
         }

         Row{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing:units.gu(3)

            /* transparent placeholder */
            Rectangle {
                 color: "transparent"
                 width: destinationUnitLabel.width
                 height: units.gu(6)
            }

            Button{
                id: doConvertionButton
                width: units.gu(25)
                color: UbuntuColors.green
                text: i18n.tr("Convert")
                onClicked:  {
                    /* Perform conversion */
                    if(Utility.isInputTextEmpty(valueToConvertField.text) || Utility.isNotNumeric(valueToConvertField.text)) {
                        PopupUtils.open(invalidInputAlert);
                    } else {
                        convertedValue.text = Storage.convertTemperature(sourceUnitChooserButton.text,destinationUnitChooserButton.text, valueToConvertField.text.trim());
                        convertedValue.enabled = true;
                    }
                }
            }
        }

        Row{
            id: infoRow
            anchors.horizontalCenter: parent.horizontalCenter

            Label{
                id:noteLabel
                text: i18n.tr("Note: the decimal separtor in use is '.'")
            }
        }

     }

}
