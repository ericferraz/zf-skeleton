<?php

namespace Application;

use Zend\Test\PHPUnit\Controller\AbstractHttpControllerTestCase;

/**
 * Class ApplicationTest
 *
 * @package Application
 * @author Jakub Igla <jakub.igla@gmail.com>
 */
class ApplicationTest extends AbstractHttpControllerTestCase
{
    public function setUp()
    {
        $this->setApplicationConfig(include './config/application.config.php');
        parent::setUp();
    }

    public function testHomePageIsDispatchable()
    {
        $this->dispatch('/');
        $this->assertResponseStatusCode(200);

        $this->assertModuleName('Application');
        $this->assertControllerClass('indexcontroller');
        $this->assertActionName('index');
        $this->assertMatchedRouteName('home');
    }
}
