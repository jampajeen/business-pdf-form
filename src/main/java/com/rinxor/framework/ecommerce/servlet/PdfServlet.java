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
package com.rinxor.framework.ecommerce.servlet;

import com.rinxor.fop.pdf.thai.FopPdfThaiFactory;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.StringReader;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.fop.apps.FOPException;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;
import org.apache.fop.servlet.ServletContextURIResolver;
import org.xml.sax.SAXException;

/**
 *
 * @author Thitipong Jampajeen <jampajeen@gmail.com>
 */
public abstract class PdfServlet extends HttpServlet implements IPdfServlet {

    protected FopFactory fopFactory;
    protected TransformerFactory transformerFactory;
    protected URIResolver uriResolver;

    @Override
    public void init() throws ServletException {

        this.uriResolver = new ServletContextURIResolver(getServletContext());

        this.transformerFactory = TransformerFactory.newInstance();
        this.transformerFactory.setURIResolver(this.uriResolver);

        try {
            this.fopFactory = FopPdfThaiFactory.newInstance((ServletContextURIResolver) this.uriResolver);

        } catch (IOException | SAXException | javax.naming.ConfigurationException | ConfigurationException ex) {
            Logger.getLogger(PdfServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    protected void writePDF(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, FOPException, TransformerException, SAXException, ConfigurationException {

        ByteArrayOutputStream out = new ByteArrayOutputStream();

        Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, out);

        Source xsltSrc = new StreamSource(getUserXSLTFilePath());
        Transformer transformer = this.transformerFactory.newTransformer(xsltSrc);

        Result res = new SAXResult(fop.getDefaultHandler());

        Source src = new StreamSource(new StringReader(getXmlData()));

        transformer.transform(src, res);

        response.setContentType("application/pdf");
        response.setContentLength(out.size());
        response.setDateHeader("Expires", System.currentTimeMillis() + 30000);

        response.getOutputStream().write(out.toByteArray());
        out.flush();
        response.getOutputStream().flush();

    }
}
