/*
 *  Power BI Visual CLI
 *
 *  Copyright (c) Microsoft Corporation
 *  All rights reserved.
 *  MIT License
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the ""Software""), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */
module powerbi.extensibility.visual {
    "use strict";
    // below is a snippet of a definition for an object which will contain the property values
    // selected by the users
    /*interface VisualSettings {
        lineColor: string;
    }*/

    // to allow this scenario you should first the following JSON definition to the capabilities.json file
    // under the "objects" property:
    // "settings": {
    //     "displayName": "Visual Settings",
    //     "description": "Visual Settings Tooltip",
    //     "properties": {
    //         "lineColor": {
    //         "displayName": "Line Color",
    //         "type": { "fill": { "solid": { "color": true }}}
    //         }
    //     }
    // }

    // in order to improve the performance, one can update the <head> only in the initial rendering.
    // set to 'true' if you are using different packages to create the widgets
    const updateHTMLHead: boolean = false;
    const renderVisualUpdateType: number[] = [
        VisualUpdateType.Resize,
        VisualUpdateType.ResizeEnd,
        VisualUpdateType.Resize + VisualUpdateType.ResizeEnd
    ];

    export class Visual implements IVisual {
        private rootElement: HTMLElement;
        private headNodes: Node[];
        private bodyNodes: Node[];
        private settings: VisualSettings;

        public constructor(options: VisualConstructorOptions) {
            if (options && options.element) {
                this.rootElement = options.element;
            }
            this.headNodes = [];
            this.bodyNodes = [];
        }

        public update(options: VisualUpdateOptions): void {

            if (!options ||
                !options.type ||
                !options.viewport ||
                !options.dataViews ||
                options.dataViews.length === 0 ||
                !options.dataViews[0]) {
                return;
            }
            const dataView: DataView = options.dataViews[0];
            this.settings = Visual.parseSettings(dataView);

            let payloadBase64: string = null;
            if (dataView.scriptResult && dataView.scriptResult.payloadBase64) {
                payloadBase64 = dataView.scriptResult.payloadBase64;
            }

            if (renderVisualUpdateType.indexOf(options.type) === -1) {
                if (payloadBase64) {
                    this.injectCodeFromPayload(payloadBase64);
                }
            } else {
                this.onResizing(options.viewport);
            }
        }

        public onResizing(finalViewport: IViewport): void {
            /* add code to handle resizing of the view port */
        }

        private injectCodeFromPayload(payloadBase64: string): void {
            // inject HTML from payload, created in R
            // the code is injected to the 'head' and 'body' sections.
            // if the visual was already rendered, the previous DOM elements are cleared

            ResetInjector();

            if (!payloadBase64) {
                return;
            }

            // create 'virtual' HTML, so parsing is easier
            let el: HTMLHtmlElement = document.createElement("html");
            try {
                el.innerHTML = window.atob(payloadBase64);
            } catch (err) {
                return;
            }

            // if 'updateHTMLHead == false', then the code updates the header data only on the 1st rendering
            // this option allows loading and parsing of large and recurring scripts only once.
            if (updateHTMLHead || this.headNodes.length === 0) {
                while (this.headNodes.length > 0) {
                    let tempNode: Node = this.headNodes.pop();
                    document.head.removeChild(tempNode);
                }
                let headList: NodeListOf<HTMLHeadElement> = el.getElementsByTagName("head");
                if (headList && headList.length > 0) {
                    let head: HTMLHeadElement = headList[0];
                    this.headNodes = ParseElement(head, document.head);
                }
            }

            // update 'body' nodes, under the rootElement
            while (this.bodyNodes.length > 0) {
                let tempNode: Node = this.bodyNodes.pop();
                this.rootElement.removeChild(tempNode);
            }
            let bodyList: NodeListOf<HTMLBodyElement> = el.getElementsByTagName("body");
            if (bodyList && bodyList.length > 0) {
                let body: HTMLBodyElement = bodyList[0];
                this.bodyNodes = ParseElement(body, this.rootElement);
            }

            RunHTMLWidgetRenderer();
        }

        private static parseSettings(dataView: DataView): VisualSettings {
            return VisualSettings.parse(dataView) as VisualSettings;
        }

        /** 
         * This function gets called for each of the objects defined in the capabilities files and allows you to select which of the 
         * objects and properties you want to expose to the users in the property pane.
         * 
         */
        public enumerateObjectInstances(options: EnumerateVisualObjectInstancesOptions): VisualObjectInstanceEnumeration {
            let objectName = options.objectName;
            let objectEnumeration = [];

			// USER - replace this block (START)
            switch (objectName) {
                case 'settings_forecastPlot_params':
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            forecastLength: Math.round(inMinMax(this.settings.settings_forecastPlot_params.forecastLength, 1, 1000000)),
                            confInterval1: this.settings.settings_forecastPlot_params.confInterval1,
                            confInterval2: this.settings.settings_forecastPlot_params.confInterval2
                        },
                        selector: null
                    });

                    break;

                case 'settings_seasonality_params':
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            show: this.settings.settings_seasonality_params.show,
                            targetSeason: this.settings.settings_seasonality_params.targetSeason,
                        },
                        selector: null
                    });
                    if (this.settings.settings_seasonality_params.targetSeason == "manual") {
                        objectEnumeration.push({
                            objectName: objectName,
                            properties: {
                                knownFrequency: inMinMax(this.settings.settings_seasonality_params.knownFrequency, 2, 1000000)
                            },
                            selector: null
                        });
                    }
                    break;

                case 'settings_model_params':
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            maxp: this.settings.settings_model_params.maxp,
                            maxd: this.settings.settings_model_params.maxd,
                            maxq: this.settings.settings_model_params.maxq                  
                        },
                    
                    });
                     if (this.settings.settings_seasonality_params.show) {
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            maxP: this.settings.settings_model_params.maxP,
                            maxD: this.settings.settings_model_params.maxD,
                            maxQ: this.settings.settings_model_params.maxQ                   
                        },
                    
                    });
                     }
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            allowDrift: this.settings.settings_model_params.allowDrift,
                            allowMean: this.settings.settings_model_params.allowMean,
                            boxCoxTransform: this.settings.settings_model_params.boxCoxTransform,                     
                        },
                   
                    });
                     if (this.settings.settings_model_params.boxCoxTransform == "manual") {
                          objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            lambda: inMinMax(this.settings.settings_model_params.lambda, -0.5, 1.5)
                        },
                      
                    });
                     }
                      objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                             stepwiseSelection: this.settings.settings_model_params.stepwiseSelection
                        },
                        selector: null
                    });
                    break;

                case 'settings_userModel_params':
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            show: this.settings.settings_userModel_params.show,
                            p: this.settings.settings_userModel_params.p,
                            d: this.settings.settings_userModel_params.d,
                            q: this.settings.settings_userModel_params.q
                           
                        },
                        selector: null
                    });
                    if (this.settings.settings_seasonality_params.show) {
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            P: this.settings.settings_userModel_params.P,
                            D: this.settings.settings_userModel_params.D,
                            Q: this.settings.settings_userModel_params.Q
                        },
                        selector: null
                    });
                    }
                    break;

                case 'settings_graph_params':
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            dataCol: this.settings.settings_graph_params.dataCol,
                            forecastCol: this.settings.settings_graph_params.forecastCol,
                            percentile: this.settings.settings_graph_params.percentile,
                            weight: this.settings.settings_graph_params.weight

                        },
                        selector: null
                    });
                    break;

                case 'settings_additional_params':
                    objectEnumeration.push({

                        objectName: objectName,
                        properties: {
                            show: this.settings.settings_additional_params.show,
                            textSize: this.settings.settings_additional_params.textSize,
                            textColor: this.settings.settings_additional_params.textColor,
                            infoCriteria: this.settings.settings_additional_params.infoCriteria
                        },
                        selector: null
                    });

                    break;
                    case 'settings_export_params':
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            show: this.settings.settings_export_params.show,
                            limitExportSize: this.settings.settings_export_params.limitExportSize,
                            method: this.settings.settings_export_params.method
                        },
                        selector: null
                    });
                    break;
            };
		// USER - replace this block (END)

            return objectEnumeration;
        }
    }
}