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

     // in order to improve the performance, one can update the <head> only in the initial rendering.
    // set to 'true' if you are using different packages to create the widgets
    const updateHTMLHead: boolean = false;
    const renderVisualUpdateType: number[] = [VisualUpdateType.Resize, VisualUpdateType.ResizeEnd, VisualUpdateType.Resize + VisualUpdateType.ResizeEnd];


	// USER - replace this block (START)
    interface VisualSettingsForecastPlotParams {
        show: boolean;
        forecastLength: number;
        confInterval1: string;
        confInterval2: string;
    }

    interface VisualSettingsSeasonalityParams {
        show: boolean;
        targetSeason: string;
        knownFrequency: number;
    }

    interface VisualSettingsModelParams {
        maxp: string;
        maxq: string;
        maxP: string;
        maxQ: string;
        maxd: string;
        maxD: string;
        allowDrift: boolean;
        allowMean: boolean;
        stepwiseSelection: boolean;
        boxCoxTransform: string;
        lambda: number;
    }
    interface VisualSettingsUserModelParams {
        show: boolean;
        p: string;
        q: string;
        P: string;
        Q: string;
        d: string;
        D: string;
    }
    interface VisualGraphParams {
        show: boolean;
        dataCol: string;
        forecastCol: string;
        percentile: number;
        weight: number;
    }
    interface VisualAdditionalParams {
        show: boolean;
        textSize: number;
        textColor: string;
        infoCriteria: string;
    }

// USER - replace this block (END)

    export class Visual implements IVisual {
       //    private imageDiv: HTMLDivElement;
        //   private imageElement: HTMLImageElement;
        //HTML
        private rootElement: HTMLElement;
        private headNodes: Node[];
        private bodyNodes: Node[];



// USER - replace this block (START)
        private settings_forecastPlot_params: VisualSettingsForecastPlotParams;
        private settings_seasonality_params: VisualSettingsSeasonalityParams;
        private settings_model_params: VisualSettingsModelParams;
        private settings_userModel_params: VisualSettingsUserModelParams;
        private settings_graph_params: VisualGraphParams;
        private settings_additional_params: VisualAdditionalParams;
// USER - replace this block (END)

        public constructor(options: VisualConstructorOptions) {
            // HTML 
             if(options && options.element)
                this.rootElement = options.element;

            this.headNodes = [];
            this.bodyNodes = [];
			
// USER - replace this block (START)
            // default parameters
            this.settings_forecastPlot_params = <VisualSettingsForecastPlotParams>{
                forecastLength: 10,
                confInterval1: "0.85",
                confInterval2: "0.95"
            };

            this.settings_seasonality_params = <VisualSettingsSeasonalityParams>{
                show: true,
                targetSeason: "automatic",
                knownFrequency: 12,
            };


            this.settings_model_params = <VisualSettingsModelParams>{
                maxp: "3",
                maxq: "3",
                maxP: "2",
                maxQ: "2",
                maxd: "2",
                maxD: "1",
                allowDrift: true,
                allowMean: true,
                stepwiseSelection: true,
                boxCoxTransform: "off",
                lambda: 0.1,
            }
            this.settings_userModel_params = <VisualSettingsUserModelParams>{
                show: false,
                p: "1",
                q: "1",
                P: "1",
                Q: "1",
                d: "1",
                D: "0",
            }


            this.settings_graph_params = <VisualGraphParams>{

                dataCol: "blue",
                forecastCol: "orange",
                percentile: 40,
                weight: 10

            };

            this.settings_additional_params = <VisualAdditionalParams>{
                show: true,
                textSize: 12,
                textColor: "brown",
                infoCriteria: "none"
            };
			
// USER - replace this block (END)
        }

        public update(options: VisualUpdateOptions) {
             if (!options || !options.type || !options.viewport)
                return;

            let dataViews: DataView[] = options.dataViews;
            if (!dataViews || dataViews.length === 0)
                return;

            let dataView: DataView = dataViews[0];
            if (!dataView || !dataView.metadata)
                return;

            this.updateObjects(dataView.metadata.objects);

            let payloadBase64: string = null;
            if (dataView.scriptResult && dataView.scriptResult.payloadBase64) {
                payloadBase64 = dataView.scriptResult.payloadBase64;
            }

            if (renderVisualUpdateType.indexOf(options.type) === -1) {
                if (payloadBase64) {
                    this.injectCodeFromPayload(payloadBase64);
                }
            }
            
            this.onResizing(options.viewport);
        }

// HTML 
         public onResizing(finalViewport: IViewport): void {
            /* add code to handle resizing of the view port */
        }

   private injectCodeFromPayload(payloadBase64: string): void {
            // Inject HTML from payload, created in R
            // the code is injected to the 'head' and 'body' sections.
            // if the visual was already rendered, the previous DOM elements are cleared

            ResetInjector();

            if (!payloadBase64) 
                return

            // create 'virtual' HTML, so parsing is easier
            let el: HTMLHtmlElement = document.createElement('html');
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
                let headList: NodeListOf<HTMLHeadElement> = el.getElementsByTagName('head');
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
            let bodyList: NodeListOf<HTMLBodyElement> = el.getElementsByTagName('body');
            if (bodyList && bodyList.length > 0) {
                let body: HTMLBodyElement = bodyList[0];
                this.bodyNodes = ParseElement(body, this.rootElement);
            }

            RunHTMLWidgetRenderer();
        }



 /**
         * This function gets called by the update function above. You should read the new values of the properties into 
         * your settings object so you can use the new value in the enumerateObjectInstances function below.
         * 
         * Below is a code snippet demonstrating how to expose a single property called "lineColor" from the object called "settings"
         * This object and property should be first defined in the capabilities.json file in the objects section.
         * In this code we get the property value from the objects (and have a default value in case the property is undefined)
         */
        public updateObjects(objects: DataViewObjects) {
          
		  
          // USER - replace this block (START)  
            this.settings_forecastPlot_params = <VisualSettingsForecastPlotParams>{
                forecastLength: getValue<number>(objects, 'settings_forecastPlot_params', 'forecastLength', 10),
                confInterval1: getValue<string>(objects, 'settings_forecastPlot_params', 'confInterval1', "0.85"),
                confInterval2: getValue<string>(objects, 'settings_forecastPlot_params', 'confInterval2', "0.95")
            };

            this.settings_seasonality_params = <VisualSettingsSeasonalityParams>{
                show: getValue<boolean>(objects, 'settings_seasonality_params', 'show', true),
                targetSeason: getValue<string>(objects, 'settings_seasonality_params', 'targetSeason', "year"),
                knownFrequency: getValue<number>(objects, 'settings_seasonality_params', 'knownFrequency', 12),

            }

            this.settings_model_params = <VisualSettingsModelParams>{
                maxp: getValue<string>(objects, 'settings_model_params', 'maxp', "3"),
                maxq: getValue<string>(objects, 'settings_model_params', 'maxq', "3"),
                maxP: getValue<string>(objects, 'settings_model_params', 'maxP', "2"),
                maxQ: getValue<string>(objects, 'settings_model_params', 'maxQ', "2"),
                maxd: getValue<string>(objects, 'settings_model_params', 'maxd', "2"),
                maxD: getValue<string>(objects, 'settings_model_params', 'maxD', "1"),
                allowDrift: getValue<boolean>(objects, 'settings_model_params', 'allowDrift', true),
                allowMean: getValue<boolean>(objects, 'settings_model_params', 'allowMean', true),
                stepwiseSelection: getValue<boolean>(objects, 'settings_model_params', 'stepwiseSelection', true),
                boxCoxTransform: getValue<string>(objects, 'settings_model_params', 'boxCoxTransform', "off"),
                lambda: getValue<number>(objects, 'settings_model_params', 'lambda', 0.1),
            }

            this.settings_userModel_params = <VisualSettingsUserModelParams>{
                show: getValue<boolean>(objects, 'settings_userModel_params', 'show', false),
                p: getValue<string>(objects, 'settings_userModel_params', 'p', "1"),
                q: getValue<string>(objects, 'settings_userModel_params', 'q', "1"),
                P: getValue<string>(objects, 'settings_userModel_params', 'P', "1"),
                Q: getValue<string>(objects, 'settings_userModel_params', 'Q', "1"),
                d: getValue<string>(objects, 'settings_userModel_params', 'd', "1"),
                D: getValue<string>(objects, 'settings_userModel_params', 'D', "0"),
            }

            this.settings_graph_params = <VisualGraphParams>{
                dataCol: getValue<string>(objects, 'settings_graph_params', 'dataCol', "blue"),
                forecastCol: getValue<string>(objects, 'settings_graph_params', 'forecastCol', "orange"),
                percentile: getValue<number>(objects, 'settings_graph_params', 'percentile', 40),
                weight: getValue<number>(objects, 'settings_graph_params', 'weight', 10),
            }

            this.settings_additional_params = <VisualAdditionalParams>{
                show: getValue<boolean>(objects, 'settings_additional_params', 'show', true),
                textSize: getValue<number>(objects, 'settings_additional_params', 'textSize', 12),
                textColor: getValue<string>(objects, 'settings_additional_params', 'textColor', "brown"),
                infoCriteria: getValue<string>(objects, 'settings_additional_params', 'infoCriteria', "none")

            }
	// USER - replace this block (END)
        }



        public enumerateObjectInstances(options: EnumerateVisualObjectInstancesOptions): VisualObjectInstanceEnumeration {
            let objectName = options.objectName;
            let objectEnumeration = [];

			// USER - replace this block (START)
            switch (objectName) {
                case 'settings_forecastPlot_params':
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            forecastLength: Math.round(inMinMax(this.settings_forecastPlot_params.forecastLength, 1, 1000000)),
                            confInterval1: this.settings_forecastPlot_params.confInterval1,
                            confInterval2: this.settings_forecastPlot_params.confInterval2
                        },
                        selector: null
                    });

                    break;

                case 'settings_seasonality_params':
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            show: this.settings_seasonality_params.show,
                            targetSeason: this.settings_seasonality_params.targetSeason,
                        },
                        selector: null
                    });
                    if (this.settings_seasonality_params.targetSeason == "manual") {
                        objectEnumeration.push({
                            objectName: objectName,
                            properties: {
                                knownFrequency: inMinMax(this.settings_seasonality_params.knownFrequency, 2, 1000000)
                            },
                            selector: null
                        });
                    }
                    break;

                case 'settings_model_params':
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            maxp: this.settings_model_params.maxp,
                            maxd: this.settings_model_params.maxd,
                            maxq: this.settings_model_params.maxq                  
                        },
                    
                    });
                     if (this.settings_seasonality_params.show) {
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            maxP: this.settings_model_params.maxP,
                            maxD: this.settings_model_params.maxD,
                            maxQ: this.settings_model_params.maxQ                   
                        },
                    
                    });
                     }
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            allowDrift: this.settings_model_params.allowDrift,
                            allowMean: this.settings_model_params.allowMean,
                            boxCoxTransform: this.settings_model_params.boxCoxTransform,                     
                        },
                   
                    });
                     if (this.settings_model_params.boxCoxTransform == "manual") {
                          objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            lambda: inMinMax(this.settings_model_params.lambda, -0.5, 1.5)
                        },
                      
                    });
                     }
                      objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                             stepwiseSelection: this.settings_model_params.stepwiseSelection
                        },
                        selector: null
                    });
                    break;

                case 'settings_userModel_params':
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            show: this.settings_userModel_params.show,
                            p: this.settings_userModel_params.p,
                            d: this.settings_userModel_params.d,
                            q: this.settings_userModel_params.q
                           
                        },
                        selector: null
                    });
                    if (this.settings_seasonality_params.show) {
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            P: this.settings_userModel_params.P,
                            D: this.settings_userModel_params.D,
                            Q: this.settings_userModel_params.Q
                        },
                        selector: null
                    });
                    }
                    break;

                case 'settings_graph_params':
                    objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                            dataCol: this.settings_graph_params.dataCol,
                            forecastCol: this.settings_graph_params.forecastCol,
                            percentile: this.settings_graph_params.percentile,
                            weight: this.settings_graph_params.weight

                        },
                        selector: null
                    });
                    break;

                case 'settings_additional_params':
                    objectEnumeration.push({

                        objectName: objectName,
                        properties: {
                            show: this.settings_additional_params.show,
                            textSize: this.settings_additional_params.textSize,
                            textColor: this.settings_additional_params.textColor,
                            infoCriteria: this.settings_additional_params.infoCriteria
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