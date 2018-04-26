module powerbi.extensibility.visual {
<<<<<<< HEAD
  "use strict";
  let injectorCounter: number = 0;
  export function ResetInjector(): void {
    injectorCounter = 0;
  }

  export function injectorReady(): boolean {
    return injectorCounter === 0;
  }
  export function ParseElement(el: HTMLElement, target: HTMLElement): Node[] {
    let arr: Node[] = [];
    if (!el || !el.hasChildNodes()) {
      return;
    }
    let nodes: HTMLCollection = el.children;
    for (let i: number = 0; i < nodes.length; i++) {
      let tempNode: HTMLElement;
      if (nodes.item(i).nodeName.toLowerCase() === "script") {
        tempNode = createScriptNode(nodes.item(i));
      } else {
=======
  let injectorCounter: number = 0;

  export function ResetInjector() : void {
    injectorCounter = 0;
  }

  export function injectorReady() : boolean {
    return injectorCounter === 0;
  }

  export function ParseElement(el: HTMLElement , target: HTMLElement) : Node[]
  {
    let arr: Node[] = [];
    if (!el || !el.hasChildNodes())
        return

    let nodes = el.children;
    for (var i=0; i<nodes.length; i++)
    {
      let tempNode: HTMLElement;
      if (nodes.item(i).nodeName.toLowerCase() === 'script'){
        tempNode = createScriptNode(nodes.item(i));
      }
      else
      {
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5
        tempNode = <HTMLElement>nodes.item(i).cloneNode(true);
      }
      target.appendChild(tempNode);
      arr.push(tempNode);
    }
    return arr;
  }

<<<<<<< HEAD
  function createScriptNode(refNode: Element): HTMLElement {
    let script: HTMLScriptElement = document.createElement("script");
    let attr: NamedNodeMap = refNode.attributes;
    for (let i: number = 0; i < attr.length; i++) {
      script.setAttribute(attr[i].name, attr[i].textContent);
      if (attr[i].name.toLowerCase() === "src") {
        // waiting only for src to finish loading - async opetation
        injectorCounter++;
        script.onload = () => {
          injectorCounter--;
        };
      }
    }
    script.innerHTML = refNode.innerHTML;
=======
  function createScriptNode(refNode: Element): HTMLElement{
    let script = document.createElement('script');
    let attr = refNode.attributes;
    for (var i=0; i<attr.length; i++)
    {
      script.setAttribute(attr[i].name, attr[i].textContent);

      if (attr[i].name.toLowerCase() === 'src') {
        // waiting only for src to finish loading
        injectorCounter++;
        script.onload = function() {
            injectorCounter--;
        };
      }
    }

    script.innerHTML = refNode.innerHTML;  
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5
    return script;
  }

  export function RunHTMLWidgetRenderer(): void {
<<<<<<< HEAD
    // rendering HTML which was created by HTMLWidgets package
    // wait till all tje script elements are loaded
    let intervalVar: number = window.setInterval(() => {
      if (injectorReady()) {
        window.clearInterval(intervalVar);
        if (window.hasOwnProperty("HTMLWidgets") && window["HTMLWidgets"].staticRender) {
          window["HTMLWidgets"].staticRender();
=======
    let intervalVar = window.setInterval(() => {
      if (injectorReady()) {
        window.clearInterval(intervalVar);
        if (window.hasOwnProperty('HTMLWidgets') && window['HTMLWidgets'].staticRender) {
          window['HTMLWidgets'].staticRender();
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5
        }
      }
    }, 100);
  }
}