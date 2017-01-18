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
        fullEnumeration: boolean;
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


    export class Visual implements IVisual {
        private imageDiv: HTMLDivElement;
        private imageElement: HTMLImageElement;

        private settings_forecastPlot_params: VisualSettingsForecastPlotParams;
        private settings_seasonality_params: VisualSettingsSeasonalityParams;
        private settings_model_params: VisualSettingsModelParams;
        private settings_userModel_params: VisualSettingsUserModelParams;
        private settings_graph_params: VisualGraphParams;
        private settings_additional_params: VisualAdditionalParams;

        public constructor(options: VisualConstructorOptions) {
            this.imageDiv = document.createElement('div');
            this.imageDiv.className = 'rcv_autoScaleImageContainer';
            options.element.appendChild(this.imageDiv);

            this.imageElement = document.createElement('img');
            this.imageElement.className = 'rcv_autoScaleImage';

            this.imageDiv.appendChild(this.imageElement);

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
                maxP: "3",
                maxQ: "3",
                maxd: "2",
                maxD: "2",
                allowDrift: true,
                allowMean: false,
                fullEnumeration: false,
                boxCoxTransform: "off",
                lambda: 0.1,
            }
            this.settings_userModel_params = <VisualSettingsUserModelParams>{
                show: false,
                p: "3",
                q: "3",
                P: "3",
                Q: "3",
                d: "2",
                D: "2",
            }


            this.settings_graph_params = <VisualGraphParams>{

                dataCol: "blue",
                forecastCol: "orange",
                percentile: 40,
                weight: 10

            };

            this.settings_additional_params = <VisualAdditionalParams>{
                show: true,
                textSize: 10,
                textColor: "gray",
                infoCriteria: "none"
            };
        }

        public update(options: VisualUpdateOptions) {
            let dataViews: DataView[] = options.dataViews;
            if (!dataViews || dataViews.length === 0)
                return;

            let dataView: DataView = dataViews[0];
            if (!dataView || !dataView.metadata)
                return;

            this.settings_forecastPlot_params = <VisualSettingsForecastPlotParams>{
                forecastLength: getValue<number>(dataView.metadata.objects, 'settings_forecastPlot_params', 'forecastLength', 10),
                confInterval1: getValue<string>(dataView.metadata.objects, 'settings_forecastPlot_params', 'confInterval1', "0.85"),
                confInterval2: getValue<string>(dataView.metadata.objects, 'settings_forecastPlot_params', 'confInterval2', "0.95")
            };

            this.settings_seasonality_params = <VisualSettingsSeasonalityParams>{
                show: getValue<boolean>(dataView.metadata.objects, 'settings_seasonality_params', 'show', true),
                targetSeason: getValue<string>(dataView.metadata.objects, 'settings_seasonality_params', 'targetSeason', "year"),
                knownFrequency: getValue<number>(dataView.metadata.objects, 'settings_seasonality_params', 'knownFrequency', 12),

            }

            this.settings_model_params = <VisualSettingsModelParams>{
                maxp: getValue<string>(dataView.metadata.objects, 'settings_model_params', 'maxp', "3"),
                maxq: getValue<string>(dataView.metadata.objects, 'settings_model_params', 'maxq', "3"),
                maxP: getValue<string>(dataView.metadata.objects, 'settings_model_params', 'maxP', "3"),
                maxQ: getValue<string>(dataView.metadata.objects, 'settings_model_params', 'maxQ', "3"),
                maxd: getValue<string>(dataView.metadata.objects, 'settings_model_params', 'maxd', "2"),
                maxD: getValue<string>(dataView.metadata.objects, 'settings_model_params', 'maxD', "2"),
                allowDrift: getValue<boolean>(dataView.metadata.objects, 'settings_model_params', 'allowDrift', true),
                allowMean: getValue<boolean>(dataView.metadata.objects, 'settings_model_params', 'allowMean', false),
                fullEnumeration: getValue<boolean>(dataView.metadata.objects, 'settings_model_params', 'fullEnumeration', false),
                boxCoxTransform: getValue<string>(dataView.metadata.objects, 'settings_model_params', 'boxCoxTransform', "off"),
                lambda: getValue<number>(dataView.metadata.objects, 'settings_model_params', 'lambda', 0.1),
            }

            this.settings_userModel_params = <VisualSettingsUserModelParams>{
                show: getValue<boolean>(dataView.metadata.objects, 'settings_userModel_params', 'show', false),
                p: getValue<string>(dataView.metadata.objects, 'settings_userModel_params', 'p', "3"),
                q: getValue<string>(dataView.metadata.objects, 'settings_userModel_params', 'q', "3"),
                P: getValue<string>(dataView.metadata.objects, 'settings_userModel_params', 'P', "3"),
                Q: getValue<string>(dataView.metadata.objects, 'settings_userModel_params', 'Q', "3"),
                d: getValue<string>(dataView.metadata.objects, 'settings_userModel_params', 'd', "2"),
                D: getValue<string>(dataView.metadata.objects, 'settings_userModel_params', 'D', "2"),
            }

            this.settings_graph_params = <VisualGraphParams>{
                dataCol: getValue<string>(dataView.metadata.objects, 'settings_graph_params', 'dataCol', "blue"),
                forecastCol: getValue<string>(dataView.metadata.objects, 'settings_graph_params', 'forecastCol', "orange"),
                percentile: getValue<number>(dataView.metadata.objects, 'settings_graph_params', 'percentile', 40),
                weight: getValue<number>(dataView.metadata.objects, 'settings_graph_params', 'weight', 10),
            }

            this.settings_additional_params = <VisualAdditionalParams>{
                show: getValue<boolean>(dataView.metadata.objects, 'settings_additional_params', 'show', true),
                textSize: getValue<number>(dataView.metadata.objects, 'settings_additional_params', 'textSize', 10),
                textColor: getValue<string>(dataView.metadata.objects, 'settings_additional_params', 'textColor', "gray"),
                infoCriteria: getValue<string>(dataView.metadata.objects, 'settings_additional_params', 'infoCriteria', "none")

            }

            let imageUrl: string = null;
            if (dataView.scriptResult && dataView.scriptResult.payloadBase64) {
                imageUrl = "data:image/png;base64," + dataView.scriptResult.payloadBase64;
            }

            if (imageUrl) {
                this.imageElement.src = imageUrl;
            } else {
                this.imageElement.src = null;
            }

            this.onResizing(options.viewport);
        }

        public onResizing(finalViewport: IViewport): void {
            this.imageDiv.style.height = finalViewport.height + 'px';
            this.imageDiv.style.width = finalViewport.width + 'px';
        }

        public enumerateObjectInstances(options: EnumerateVisualObjectInstancesOptions): VisualObjectInstanceEnumeration {
            let objectName = options.objectName;
            let objectEnumeration = [];

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
                            lambda: inMinMax(this.settings_model_params.lambda, -1, 2)
                        },
                      
                    });
                     }
                      objectEnumeration.push({
                        objectName: objectName,
                        properties: {
                             fullEnumeration: this.settings_model_params.fullEnumeration
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

            return objectEnumeration;
        }
    }
}