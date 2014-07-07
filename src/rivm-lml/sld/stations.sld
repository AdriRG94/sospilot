<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld"
                       xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <!-- a Named Layer is the basic building block of an SLD document -->
    <NamedLayer>
        <Name>stations</Name>
        <UserStyle>
            <!-- Styles can have names, titles and abstracts -->
            <Title>RIVM Stations</Title>
            <Abstract>RIVM Stations style</Abstract>
            <!-- FeatureTypeStyles describe how to render different features -->
            <!-- A FeatureTypeStyle for rendering points -->
            <FeatureTypeStyle>
                <Rule>
                    <Name>Active Stations</Name>
                    <ogc:Filter>

                            <ogc:PropertyIsNull>
                                <ogc:PropertyName>activity_end</ogc:PropertyName>
                            </ogc:PropertyIsNull>

                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>triangle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#ee7600</CssParameter>
                                    <CssParameter name="fill-opacity">0.6</CssParameter>
                                </Fill>
                                <Stroke>
                                    <CssParameter name="stroke">#222222</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>12</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>

            </FeatureTypeStyle>
            <FeatureTypeStyle>

                <Rule>
                    <Name>Inactive Stations</Name>
                    <ogc:Filter>
                        <ogc:Not>

                        <ogc:PropertyIsNull>
                            <ogc:PropertyName>activity_end</ogc:PropertyName>
                        </ogc:PropertyIsNull>
                        </ogc:Not>

                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>triangle</WellKnownName>
                                <Fill>
                                    <CssParameter name="fill">#dddddd</CssParameter>
                                    <CssParameter name="fill-opacity">0.6</CssParameter>
                                </Fill>
                                <Stroke>
                                    <CssParameter name="stroke">#222222</CssParameter>
                                    <CssParameter name="stroke-width">1</CssParameter>
                                </Stroke>
                            </Mark>
                            <Size>12</Size>
                        </Graphic>
                    </PointSymbolizer>

                </Rule>

            </FeatureTypeStyle>

        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
