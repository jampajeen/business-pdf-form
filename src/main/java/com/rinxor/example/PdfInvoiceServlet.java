/*
 * Copyright 2014 Thitipong Jampajeen <jampajeen@gmail.com>.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.rinxor.example;

import com.rinxor.framework.ecommerce.servlet.IPdfServlet;
import com.rinxor.framework.ecommerce.servlet.PdfServlet;
import java.io.IOException;
import java.io.StringWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;
import javax.xml.transform.TransformerException;
import org.apache.fop.apps.FOPException;

/**
 *
 * @author Thitipong Jampajeen <jampajeen@gmail.com>
 * 
 * Use Template Method pattern
 */
public class PdfInvoiceServlet extends PdfServlet implements IPdfServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        try {
            
            this.writePDF( request, response);
            
        } catch (FOPException | TransformerException ex) {
            Logger.getLogger(PdfInvoiceServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getXmlData() {
        String xmlData = null;
        
        try {
            
            StringWriter out = new StringWriter();
            XMLOutputFactory factory = XMLOutputFactory.newInstance();
            XMLStreamWriter writer = factory.createXMLStreamWriter(out);
            
            writer.writeStartDocument("utf-8", "1.0");
            
            writer.writeStartElement("Invoice");
            writer.writeAttribute("OrderId", "IV123456789");
            
            writer.writeStartElement("OrderDate");
            writer.writeCharacters("2014-12-14 20:05:00");
            writer.writeEndElement();
            
            writer.writeStartElement("CompanyAddress");
            
            writer.writeStartElement("HeaderLogo");
            writer.writeCharacters(getServletContext().getRealPath("/images/logo.png"));
            writer.writeEndElement();
            
            writer.writeStartElement("CompanyName");
            writer.writeCharacters("รินเซอร์");
            writer.writeEndElement();
            
            writer.writeStartElement("StreetAddress");
            writer.writeCharacters("สุทธิสาร");
            writer.writeEndElement();
            
            writer.writeStartElement("City");
            writer.writeCharacters("ห้วยขวาง");
            writer.writeEndElement();
            
            writer.writeStartElement("State");
            writer.writeCharacters("กรุงเทพฯ");
            writer.writeEndElement();
            
            writer.writeStartElement("ZipCode");
            writer.writeCharacters("10310");
            writer.writeEndElement();
            
            writer.writeEndElement();
            
            writer.writeStartElement("CustomerAddress");
            
            writer.writeStartElement("CompanyName");
            writer.writeCharacters("ลูกค้า");
            writer.writeEndElement();
            
            writer.writeStartElement("StreetAddress");
            writer.writeCharacters("");
            writer.writeEndElement();
            
            writer.writeStartElement("City");
            writer.writeCharacters("");
            writer.writeEndElement();
            
            writer.writeStartElement("State");
            writer.writeCharacters("เชียงใหม่");
            writer.writeEndElement();
            
            writer.writeStartElement("ZipCode");
            writer.writeCharacters("");
            writer.writeEndElement();
            
            writer.writeEndElement();
            
            writer.writeStartElement("Items");
            
            writer.writeStartElement("Item");
            writer.writeAttribute("ItemId", "12345");
            writer.writeAttribute("ItemName", "Microsoft Mouse");
            writer.writeAttribute("Quantity", "10");
            writer.writeAttribute("ItemCost", "100.5");
            writer.writeEndElement();
            
            writer.writeStartElement("Item");
            writer.writeAttribute("ItemId", "12346");
            writer.writeAttribute("ItemName", "Microsoft Mouse V2");
            writer.writeAttribute("Quantity", "20");
            writer.writeAttribute("ItemCost", "120");
            writer.writeEndElement();
            
            writer.writeEndElement();
            
            writer.writeEndElement();
            
            writer.writeEndDocument();
            
            writer.flush();
            writer.close();
            
            xmlData = out.toString();
            
        } catch (XMLStreamException ex) {
            Logger.getLogger(PdfInvoiceServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return xmlData;
    }

    @Override
    public String getFopConfigFilePath() {
        return getServletContext().getRealPath("/WEB-INF/fop-th.xconf");
    }

    @Override
    public String getUserXSLTFilePath() {
        return getServletContext().getRealPath("/xslt/Invoice.xsl");
    }
}
